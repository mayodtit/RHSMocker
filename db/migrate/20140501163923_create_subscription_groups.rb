class CreateSubscriptionGroups < ActiveRecord::Migration
  def change
    create_table :subscription_groups do |t|
      t.references :owner
      t.timestamps
    end
  end
end
