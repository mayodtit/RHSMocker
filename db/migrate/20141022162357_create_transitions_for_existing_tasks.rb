class CreateTransitionsForExistingTasks < ActiveRecord::Migration
  def up
    # Go through tasks without task changes and create them based on timestamps. Not perfect, but will allow us to remove those fields.
    Task.joins("LEFT JOIN `task_changes` ON `task_changes`.`task_id` = `tasks`.`id`").where("`task_changes`.`task_id` is NULL").find_each do |task|
      puts "PROCESSING TASK #{task.id}"

      if !task.owner_id || Member.where(id: task.owner_id).count == 0
        puts "\tSKIPPING - Owner doesn't exist"
        next
      end

      if task.assigned_at
        if task.assignor_id & Member.where(id: task.assignor_id).count > 0
          TaskChange.create!(task: task, actor_id: task.assignor_id, created_at: task.assigned_at, data: {"owner_id" => [nil, task.owner_id]}.to_s)
        else
          puts "\tSKIPPING ASSIGNMENT CHANGE - Assignor doesn't exist"
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

  def down
    # Do nothing
  end
end
