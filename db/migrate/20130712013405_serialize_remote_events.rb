class SerializeRemoteEvents < ActiveRecord::Migration
  def up
    add_column :remote_events, :data, :text
    remove_column :remote_events, :name
    remove_column :remote_events, :device_created_at
    remove_column :remote_events, :device_language
    remove_column :remote_events, :device_os
    remove_column :remote_events, :device_os_version
    remove_column :remote_events, :device_model
    remove_column :remote_events, :device_timezone_offset
    remove_column :remote_events, :app_version
    remove_column :remote_events, :app_build
  end

  def down
    remove_column :remote_events, :data
    add_column :remote_events, :name, :string
    add_column :remote_events, :device_created_at, :integer
    add_column :remote_events, :device_language, :string
    add_column :remote_events, :device_os, :string
    add_column :remote_events, :device_os_version, :string
    add_column :remote_events, :device_model, :string
    add_column :remote_events, :device_timezone_offset, :integer
    add_column :remote_events, :app_version, :string
    add_column :remote_events, :app_build, :string
  end
end
