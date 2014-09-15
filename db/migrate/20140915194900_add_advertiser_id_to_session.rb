class AddAdvertiserIdToSession < ActiveRecord::Migration
  def change
    add_column :sessions, :advertiser_id, :string
  end
end
