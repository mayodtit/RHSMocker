class RemoveDefaultPriorityFromTasks < ActiveRecord::Migration
  def up
    change_column :tasks, :priority, :integer, null: true, default: nil
  end

  def down
    change_column :tasks, :priority, :integer, null: false, default: 0
  end
end
