class AddUnreadToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :unread, :boolean, default: false, null: false
  end
end
