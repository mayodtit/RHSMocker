class AddIndexesToSessions < ActiveRecord::Migration
  def change
    add_index :sessions, :auth_token, unique: true
    add_index :sessions, :device_id
    add_index :sessions, :apns_token, unique: true
    add_index :sessions, :gcm_id, unique: true
  end
end
