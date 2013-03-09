class RenameUserFields < ActiveRecord::Migration
  def change
    rename_column :users, :birthDate, :birth_date
    rename_column :users, :firstName, :first_name
    rename_column :users, :imageURL, :image_url
    rename_column :users, :lastName, :last_name
  end
end
