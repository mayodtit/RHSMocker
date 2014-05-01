class CreateSubscriptionUsers < ActiveRecord::Migration
  def change
    create_table :subscription_users do |t|
      t.references :subscription
      t.references :user
      t.timestamps
    end
  end
end
