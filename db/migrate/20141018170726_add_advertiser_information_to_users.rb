class AddAdvertiserInformationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :advertiser_id, :string
    add_column :users, :advertiser_media_source, :string
    add_column :users, :advertiser_campaign, :string
  end
end
