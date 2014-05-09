class AddDefaultsToOnboardingGroup < ActiveRecord::Migration
  def up
    change_column :onboarding_groups, :free_trial_days, :integer, null: false, default: 0
  end

  def down
    change_column :onboarding_groups, :free_trial_days, :integer, null: true, default: nil
  end
end
