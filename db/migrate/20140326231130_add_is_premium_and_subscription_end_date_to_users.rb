class AddIsPremiumAndSubscriptionEndDateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_premium, :boolean, default: false
    add_column :users, :subscription_end_date, :datetime
  end
end
