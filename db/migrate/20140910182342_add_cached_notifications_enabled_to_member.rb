class AddCachedNotificationsEnabledToMember < ActiveRecord::Migration
  def change
    add_column :users, :cached_notifications_enabled, :boolean
  end
end
