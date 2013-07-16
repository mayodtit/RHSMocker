class AddUnlimitedToUserOfferings < ActiveRecord::Migration
  def change
    add_column :user_offerings, :unlimited, :boolean, :null => false, :default => false
  end
end
