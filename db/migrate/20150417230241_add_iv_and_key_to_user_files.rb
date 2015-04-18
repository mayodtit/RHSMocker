class AddIvAndKeyToUserFiles < ActiveRecord::Migration
  def change
    add_column :user_files, :iv, :binary
    add_column :user_files, :key, :binary
  end
end
