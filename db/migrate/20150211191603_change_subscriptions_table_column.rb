class ChangeSubscriptionsTableColumn < ActiveRecord::Migration
  def change
    remove_column :subscriptions, :start
    remove_column :subscriptions, :current_period_start
    remove_column :subscriptions, :current_period_end
    add_column :subscriptions, :start, :integer, :null => false
    add_column :subscriptions, :current_period_start, :integer, :null => false
    add_column :subscriptions, :current_period_end, :integer, :null => false
  end
end
