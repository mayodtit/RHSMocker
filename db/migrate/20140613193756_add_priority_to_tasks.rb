class AddPriorityToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :priority, :integer, null: false, default: 0
  end
end
