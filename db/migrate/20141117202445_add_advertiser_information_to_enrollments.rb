class AddAdvertiserInformationToEnrollments < ActiveRecord::Migration
  def change
    add_column :enrollments, :advertiser_media_source, :string
    add_column :enrollments, :advertiser_campaign, :string
  end
end
