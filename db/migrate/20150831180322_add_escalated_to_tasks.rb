class AddEscalatedToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :escalated, :boolean, default: false, null: false
  end
end
