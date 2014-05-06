class AddMetadataForEnableSharing < ActiveRecord::Migration
  def up
    Metadata.find_or_create_by_mkey('enable_sharing').update_attribute(:mvalue, 'false')
  end

  def down
    Metadata.find_by_mkey('enable_sharing').try(:destroy)
  end
end
