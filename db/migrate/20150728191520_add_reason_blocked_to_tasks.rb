class AddReasonBlockedToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :reason_blocked, :text
  end
end
