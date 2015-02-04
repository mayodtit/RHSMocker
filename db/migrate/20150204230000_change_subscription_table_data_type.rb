class ChangeSubscriptionTableDataType < ActiveRecord::Migration
  def change
    remove_column :subscriptions, :plan_id
    remove_column :subscriptions, :canceled_at
    add_column :subscriptions, :plan_id, :string, null: false
    add_column :subscriptions, :canceled_at, :datetime
  end
end
