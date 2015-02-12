class ChangeSubscriptionValidations < ActiveRecord::Migration
  def change
    remove_column :subscriptions, :current_period_start
    remove_column :subscriptions, :current_period_end
    remove_column :subscriptions, :stripe_subscription_id
    remove_column :subscriptions, :start
    add_column :subscriptions, :stripe_subscription_id, :string
    add_column :subscriptions, :current_period_start, :integer
    add_column :subscriptions, :current_period_end, :integer
    add_column :subscriptions, :start, :integer
  end
end
