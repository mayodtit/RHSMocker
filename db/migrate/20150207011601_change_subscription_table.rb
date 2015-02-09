class ChangeSubscriptionTable < ActiveRecord::Migration
  def change
    remove_column :subscriptions, :plan_id
    remove_column :subscriptions, :disabled_at
    add_column :subscriptions, :plan, :text, null: false
  end
end
