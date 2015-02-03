class AddUniquenessForOwnerIdAndCustomer < ActiveRecord::Migration
  def up
    add_column :subscriptions, :owner_id, :integer, :unique => true, :null => false
    add_column :subscriptions, :plan_id, :integer, :unique => true, :null => false
  end

  def down
    remove_column :subscriptions, :owner_id
    remove_column :subscriptions, :plan_id
  end
end
