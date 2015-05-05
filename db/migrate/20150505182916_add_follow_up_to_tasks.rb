class AddFollowUpToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :follow_up, :boolean, default: false, null: false
  end
end
