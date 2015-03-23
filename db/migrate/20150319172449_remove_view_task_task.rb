class RemoveViewTaskTask < ActiveRecord::Migration
  def up
    remove_column :tasks, :assigned_task_id
  end

  def down
    add_column :tasks, :assigned_task_id, :integer
  end
end
