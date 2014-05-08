class AddFreeTrialEndsAtToFeatureGroup < ActiveRecord::Migration
  def change
    add_column :feature_groups, :free_trial_ends_at, :datetime
  end
end
