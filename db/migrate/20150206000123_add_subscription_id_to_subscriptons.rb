class AddSubscriptionIdToSubscriptons < ActiveRecord::Migration
  def change
    add_column :subscriptions, :stripe_subscription_id, :string, null: false, unique: true
  end
end
