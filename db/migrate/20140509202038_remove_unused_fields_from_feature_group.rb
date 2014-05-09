class RemoveUnusedFieldsFromFeatureGroup < ActiveRecord::Migration
  def up
    remove_column :feature_groups, :premium
    remove_column :feature_groups, :free_trial_days
    remove_column :feature_groups, :free_trial_ends_at
  end

  def down
    add_column :feature_groups, :premium, :boolean, null: false, default: false
    add_column :feature_groups, :free_trial_days, :integer
    add_column :feature_groups, :free_trial_ends_at, :datetime
  end
end
