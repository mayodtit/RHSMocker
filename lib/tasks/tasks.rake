namespace :tasks do
  desc "Generate task changes for tasks don't have any"
  task :backfill_changes => :environment do
    Task.joins("LEFT JOIN `task_changes` ON `task_changes`.`task_id` = `tasks`.`id`").where("`task_changes`.`task_id` is NULL").find_each do |task|
      puts "Processing #{task.type} #{task.id}"

      if !task.owner_id || Member.where(id: task.owner_id).count == 0
        puts "\tSkipping - Owner doesn't exist"
        next
      end

      if task.assigned_at
        if task.assignor_id & Member.where(id: task.assignor_id).count > 0
          TaskChange.create!(task: task, actor_id: task.assignor_id, created_at: task.assigned_at, data: {"owner_id" => [nil, task.owner_id]})
        else
          puts "\tSkipping assignment change - Assignor doesn't exist"
        end
      end

      if task.started_at
        TaskChange.create!(task: task, actor_id: task.owner_id, created_at: task.started_at, event: 'start', from: 'unstarted', to: 'started')
      end

      if task.claimed_at
        TaskChange.create!(task: task, actor_id: task.owner_id, created_at: task.claimed_at, event: 'claim', from: 'started', to: 'claimed')
      end

      if task.completed_at
        TaskChange.create!(task: task, actor_id: task.owner_id, created_at: task.completed_at, event: 'complete', from: 'claimed', to: 'completed')
      end

      if task.abandoned_at
        TaskChange.create!(task: task, actor_id: task.abandoner_id, created_at: task.abandoned_at, event: 'abandon', from: 'claimed', to: 'abandoned', data: {"reason_abandoned" => [nil, task.reason_abandoned]})
      end
    end
  end

  desc "Backfill tasks that should have a member"
  task :backfill_member => :environment do
    Task.where(member_id: nil).find_each do |task|
      puts "Processing #{task.type} #{task.id}"
      if task.respond_to? :set_member
        task.set_member
        puts "\tSetting member to #{task.member_id}"
        begin
          task.save!
        rescue
          # Do nothing, continue
        end
      end
    end
  end

  desc "Backfill welcome calls without a task"
  task :backfill_welcome_calls => :environment do
    ScheduledPhoneCall.joins('LEFT JOIN tasks ON scheduled_phone_calls.id = tasks.scheduled_phone_call_id').where('tasks.scheduled_phone_call_id IS NULL AND scheduled_phone_calls.scheduled_at > ?', Time.now).where(state: 'booked').find_each do |call|
      puts "Processing cheduled phone call #{call.id}"
      if call.respond_to? :create_task
        call.create_task
        puts "\tCreating WelcomeCallTask for scheduled phone call #{call.id}"
        begin
          call.save!
        rescue
          # Do nothing, continue
        end
      end
    end
  end

  desc "Convert task changes with strings to hashes"
  task :convert_task_changes_with_string_to_hash => :environment do
    with_string = TaskChange.where 'data IS NOT NULL AND data NOT LIKE "--- %"'
    puts "Converting #{with_string.count} old task changes"
    with_string.find_each do |task_change|
      next unless task_change.data.is_a? String
      # Convert timestamps to valid ruby (e.g. Time.parse("[TIMESTAMP]"))
      converted_data = task_change.data.gsub(/([a-zA-z][a-zA-z][a-zA-z], \d\d [a-zA-z][a-zA-z][a-zA-z] \d\d\d\d \d\d:\d\d:\d\d [a-zA-z][a-zA-z][a-zA-z] \+\d\d:\d\d)/, 'Time.parse("\1")')
      task_change.data = eval converted_data
      task_change.save!

    end
  end


  desc "Backfill reason for task changes that transition to abandoned"
  task :backfill_reason => :environment do
    TaskChange.where(to: 'abandoned', reason: nil).includes(:task).find_each do |task_change|
      puts "Backfilling reason for change #{task_change.id} from task #{task_change.task.id}"
      task_change.data.delete 'reason_abandoned'
      task_change.data = nil if task_change.data.empty?
      task_change.reason = task_change.task.reason_abandoned
      task_change.save!
    end
  end

  desc "Recalculate Member.last_contact_at"
    task :recalculate_member_last_contact_at => :environment do
    Member.find_each do |m|
      if m.master_consult
        consult_last_contact_at = m.master_consult.created_at
        Message.where('consult_id = ? AND user_id <> ? AND (system IS NULL OR system <> 1) AND phone_call_summary_id IS NULL AND note <> 1', m.master_consult.id, m.id).order('created_at DESC').each do |msg|
          if (!(msg.phone_call && msg.phone_call.to_nurse?) && consult_last_contact_at < msg.created_at)
            consult_last_contact_at = msg.created_at
            break
          end
        end

        puts "Updating Member #{m.id} last contact at from #{m.last_contact_at} to #{consult_last_contact_at}"
        m.last_contact_at = consult_last_contact_at
        begin
          m.save!
        rescue
          # Skip
        end
      end
    end
  end

  desc "Send Members OOO message"
    task :holiday_ooo_message => :environment do
      holidayMessage = "We hope you're having a wonderful holiday week! Our PHA team will be offline from 12PM PST today through 12/25. They'll be back on Friday. In the meantime, if you have any symptoms or medical questions, tap the phone icon to talk to a Mayo Clinic nurse."
      newYearsMessage = "Tomorrow our team of PHAs will be offline. They’ll be back on 1/2 to support you with your New Year’s resolutions. As always, Mayo Clinic nurses are available 24/7. Tap the phone icon to connect. Cheers to a healthy New Year!"
      Member.premium_states.each do |m|
        if( ScheduledSystemMessage.where(recipient_id: m.id, text: holidayMessage, state: :scheduled).count == 0 )
          ScheduledSystemMessage.create(sender: Member.robot,
                                        recipient: m,
                                        publish_at: Time.parse('24 Dec 2014 08:00:00 PST -08:00'),
                                        text: holidayMessage)
        end
        if( ScheduledSystemMessage.where(recipient_id: m.id, text: newYearsMessage, state: :scheduled).count == 0 )
          ScheduledSystemMessage.create(sender: Member.robot,
                                        recipient: m,
                                        publish_at: Time.parse('31 Dec 2014 08:00:00 PST -08:00'),
                                        text: newYearsMessage)
        end
      end
    end

  desc "Backfill timeline message entries"
  task :backfill_timeline_messages => :environment do
    Message.find_each do |message|
      print '.'
      if !Entry.exists?(resource_id: message.id) && !(message.phone_call || message.scheduled_phone_call || message.phone_call_summary)
        begin
          message.consult.initiator.entries.create(resource: message, actor: message.user, data: message.entry_serializer.as_json)
        rescue
          puts "Error with message: #{message.id}\n"
        end
      end
    end
  end

  desc "Backfill unstarted/started tasks to unclaimed/claimed"
  task :backfill_tasks_from_unstarted_started_to_claimed_unclaimed => :environment do
    puts "Updating unstarted tasks without a member to unclaimed tasks\n:"
    Task.where(state: :unstarted, owner_id: nil).update_all(state: :unclaimed)

    puts "Updating unstarted tasks without a member to claiemd tasks \n:"
    Task.where(state: :unstarted).where('owner_id IS NOT NULL').update_all("state = 'claimed', claimed_at = assigned_at")

    puts "Updating started tasks to claimed tasks \n:"
    Task.where(state: :started).update_all("state = 'claimed', claimed_at = assigned_at")
  end

  desc "Backfill tasks with queues"
  task :backfill_tasks_with_queues => :environment do
    puts "Updating open tasks with the correct queue...\n"
    Task.open_state.find_each do |t|
      if t.owner.try(:specialist?)
        t.update_attribute(:queue, :specialist)
      elsif t.for_nurse?
        t.update_attribute(:queue, :nurse)
      elsif t.type == 'PhoneCallTask'
        t.update_attribute(:queue, :hcc)
      elsif t.type == 'MessageTask'
        if t.owner_id && t.message.consult.initiator.pha_id == t.owner_id
          t.update_attribute(:queue, :pha)
        else
          t.update_attribute(:queue, :hcc)
        end
      else
        t.update_attribute(:queue, t.default_queue)
      end
    end

    puts "Updating message tasks to HCC queue...\n"
    MessageTask.where(state: %i(completed abandoned)).update_all(queue: :hcc)

    puts "Updating member tasks to PHA queue...\n"
    MemberTask.where(state: %i(completed abandoned)).update_all(queue: :pha)

    puts "Updating nurse PhoneCallTasks to nurse queue...\n"
    PhoneCallTask.joins(:role).where(state: %i(completed abandoned)).where('roles.name = "nurse"').update_all(queue: :nurse)

    puts "Updating other PhoneCallTasks to hcc queue...\n"
    PhoneCallTask.joins(:role).where(state: %i(completed abandoned)).where('roles.name <> "nurse"').update_all(queue: :hcc)

    puts "Updating all other tasks to PHA queue..\n"
    Task.where(state: %i(completed abandoned)).where(queue: nil).update_all(queue: :pha)
  end
end
