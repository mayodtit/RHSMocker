class AddViewTaskTaskToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :assigned_task_id, :integer
  end
end
