class RenameUserPlanToSubscription < ActiveRecord::Migration
  def up
    remove_index :user_plans, :plan_id
    remove_index :user_plans, :user_id
    rename_table :user_plans, :subscriptions
  end

  def down
    rename_table :subscriptions, :user_plans
    add_index :user_plans, :plan_id
    add_index :user_plans, :user_id
  end
end
