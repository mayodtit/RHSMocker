class AddColumnsToSusbscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :status, :string, :null => false
    add_column :subscriptions, :customer, :string, :null => false
    add_column :subscriptions, :cancel_at_period_end, :boolean, :default => false, :null => false
    add_column :subscriptions, :ended_at, :datetime
    add_column :subscriptions, :trial_start, :datetime
    add_column :subscriptions, :trial_end, :datetime
    add_column :subscriptions, :quantity, :integer, :null => false
    add_column :subscriptions, :application_fee_percent, :decimal
    add_column :subscriptions, :tax_percent, :decimal
    add_column :subscriptions, :discount, :text
    add_column :subscriptions, :metadata, :text
    add_column :subscriptions, :canceled_at, :datetime
    add_column :subscriptions, :plan, :text, :null => false
    add_column :subscriptions, :is_current, :boolean, :default => false, :null => false
    add_column :subscriptions, :stripe_subscription_id, :string
    add_column :subscriptions, :current_period_start, :integer
    add_column :subscriptions, :current_period_end, :integer
    add_column :subscriptions, :start, :integer
    rename_column :subscriptions, :owner_id, :user_id
  end
end
