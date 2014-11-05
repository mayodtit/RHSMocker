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
          TaskChange.create!(task: task, actor_id: task.assignor_id, created_at: task.assigned_at, data: {"owner_id" => [nil, task.owner_id]}.to_s)
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
        TaskChange.create!(task: task, actor_id: task.abandoner_id, created_at: task.abandoned_at, event: 'abandon', from: 'claimed', to: 'abandoned', data: {"reason_abandoned" => [nil, task.reason_abandoned]}.to_s)
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

  desc "Convert task changes with strings to hashes"
  task :convert_task_changes_with_string_to_hash => :environment do
    with_string = TaskChange.where 'data IS NOT NULL AND data NOT LIKE "--- %"'
    puts "Converting #{with_string.count} old task changes"
    with_string.find_each do |task_change|
      # Convert timestamps to valid ruby (e.g. Time.parse("[TIMESTAMP]"))
      converted_data = task_change.data.gsub(/([a-zA-z][a-zA-z][a-zA-z], \d\d [a-zA-z][a-zA-z][a-zA-z] \d\d\d\d \d\d:\d\d:\d\d [a-zA-z][a-zA-z][a-zA-z] \+\d\d:\d\d)/, 'Time.parse("\1")')
      task_change.data = eval converted_data
      task_change.save!
    end
  end
end
