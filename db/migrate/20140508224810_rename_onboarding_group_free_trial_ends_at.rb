class RenameOnboardingGroupFreeTrialEndsAt < ActiveRecord::Migration
  def up
    rename_column :onboarding_groups, :free_trial_ends_at, :absolute_free_trial_ends_at
  end

  def down
    rename_column :onboarding_groups, :absolute_free_trial_ends_at, :free_trial_ends_at
  end
end
