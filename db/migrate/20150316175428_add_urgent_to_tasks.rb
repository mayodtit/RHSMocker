class AddUrgentToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :urgent, :boolean, default: false, null: false
  end
end
