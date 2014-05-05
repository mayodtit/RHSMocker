class RenameSubscriptionEndDate < ActiveRecord::Migration
  def up
    rename_column :users, :subscription_end_date, :free_trial_ends_at
  end

  def down
    rename_column :users, :free_trial_ends_at, :subscription_end_date
  end
end
