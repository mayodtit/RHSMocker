class RenameSubscriptionOwnerId < ActiveRecord::Migration
  def up
    rename_column :subscriptions, :owner_id, :user_id
  end

  def down
    rename_column :subscriptions, :user_id, :owner_id
  end
end
