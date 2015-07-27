class RemoveCompletedFromTaskSteps < ActiveRecord::Migration
  def up
    remove_column :task_steps, :completed
  end

  def down
    add_column :task_steps, :completed, :boolean
  end
end
