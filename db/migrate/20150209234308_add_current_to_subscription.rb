class AddCurrentToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :is_current, :boolean
  end
end
