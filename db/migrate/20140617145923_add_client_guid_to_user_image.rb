class AddClientGuidToUserImage < ActiveRecord::Migration
  def change
    add_column :user_images, :client_guid, :string
  end
end
