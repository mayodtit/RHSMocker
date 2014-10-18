class AddIndexToSessionsAdvertiserId < ActiveRecord::Migration
  def change
    add_index :sessions, :advertiser_id
  end
end
