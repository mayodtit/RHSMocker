class RenameAuthorColumns < ActiveRecord::Migration
  def change
    rename_column :authors, :imageURL, :image_url
    rename_column :authors, :shortName, :short_name
  end
end
