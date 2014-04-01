class AddStripeIdToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :stripe_id, :string
  end
end
