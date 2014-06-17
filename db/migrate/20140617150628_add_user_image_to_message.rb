class AddUserImageToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :user_image_id, :integer
  end
end
