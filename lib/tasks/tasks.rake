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

        m.last_contact_at = consult_last_contact_at
        m.save!
      end
    end
  end
end
