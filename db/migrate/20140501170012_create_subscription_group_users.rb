class CreateSubscriptionGroupUsers < ActiveRecord::Migration
  def change
    create_table :subscription_group_users do |t|
      t.references :subscription_group
      t.references :user
      t.timestamps
    end
  end
end
