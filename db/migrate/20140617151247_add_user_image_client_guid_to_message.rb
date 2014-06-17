class AddUserImageClientGuidToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :user_image_client_guid, :string
  end
end
