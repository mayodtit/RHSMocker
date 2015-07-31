class AddCompletedAtToTaskSteps < ActiveRecord::Migration
  def change
    add_column :task_steps, :completed_at, :datetime
  end
end
