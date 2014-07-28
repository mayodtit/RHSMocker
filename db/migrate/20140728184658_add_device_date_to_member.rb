class AddDeviceDateToMember < ActiveRecord::Migration
  def change
    add_column :users, :device_os, :string
    add_column :users, :device_app_version, :string
    add_column :users, :device_app_build, :string
    add_column :users, :device_timezone, :string
    add_column :users, :device_notifications_enabled, :boolean
  end
end
