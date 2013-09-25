class RenameImageUrlToAvatar < ActiveRecord::Migration
  def change
    rename_column :users, :image_url, :avatar
  end
end
