class AddDayPriorityToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :day_priority, :integer, default: 0, null: false
  end
end
