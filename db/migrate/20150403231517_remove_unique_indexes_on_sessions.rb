class RemoveUniqueIndexesOnSessions < ActiveRecord::Migration
  def up
    remove_index :sessions, :apns_token
    remove_index :sessions, :gcm_id
  end

  def down
    add_index :sessions, :apns_token, unique: true
    add_index :sessions, :gcm_id, unique: true
  end
end
