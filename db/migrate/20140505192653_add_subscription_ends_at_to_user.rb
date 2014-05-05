class AddSubscriptionEndsAtToUser < ActiveRecord::Migration
  def change
    add_column :users, :subscription_ends_at, :datetime
  end
end
