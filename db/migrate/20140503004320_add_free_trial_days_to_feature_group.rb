class AddFreeTrialDaysToFeatureGroup < ActiveRecord::Migration
  def change
    add_column :feature_groups, :free_trial_days, :integer
  end
end
