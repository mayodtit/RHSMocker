class AddGcmIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :gcm_id, :string
  end
end
