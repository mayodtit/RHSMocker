class AddDeviceModelToSession < ActiveRecord::Migration
  def change
    add_column :sessions, :device_model, :string
  end
end
