class AddAvatarUrlOverrideToUser < ActiveRecord::Migration
  def change
    add_column :users, :avatar_url_override, :string
  end
end
