class AddDeviceOsVersionToSession < ActiveRecord::Migration
  def change
    add_column :sessions, :device_os_version, :string
  end
end
