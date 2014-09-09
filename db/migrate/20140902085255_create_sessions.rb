class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.references :member
      t.string :auth_token
      t.string :device_id
      t.string :apns_token
      t.string :gcm_id
      t.string :device_os
      t.string :device_app_version
      t.string :device_app_build
      t.string :device_timezone
      t.boolean :device_notifications_enabled
      t.timestamps
    end
  end
end
