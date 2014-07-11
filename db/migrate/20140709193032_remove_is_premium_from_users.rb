class RemoveIsPremiumFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :is_premium
  end

  def down
    add_column :users, :is_premium, :boolean, default: false
  end
end
