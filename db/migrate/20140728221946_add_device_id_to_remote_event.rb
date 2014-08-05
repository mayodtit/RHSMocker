class AddDeviceIdToRemoteEvent < ActiveRecord::Migration
  def change
    add_column :remote_events, :device_id, :string
  end
end
