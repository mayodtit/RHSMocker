class RemoveDeviceInformationFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :install_id
    remove_column :users, :auth_token
    remove_column :users, :holds_phone_in
    remove_column :users, :apns_token
    remove_column :users, :gcm_id
    remove_column :users, :device_os
    remove_column :users, :device_app_version
    remove_column :users, :device_app_build
    remove_column :users, :device_timezone
    remove_column :users, :device_notifications_enabled
  end

  def down
    add_column :users, :install_id, :string, limit: 36
    add_column :users, :auth_token, :string
    add_column :users, :holds_phone_in, :string
    add_column :users, :apns_token, :string
    add_column :users, :gcm_id, :string
    add_column :users, :device_os, :string
    add_column :users, :device_app_version, :string
    add_column :users, :device_app_build, :string
    add_column :users, :device_timezone, :string
    add_column :users, :device_notifications_enabled, :boolean
  end
end
