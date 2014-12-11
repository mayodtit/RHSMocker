class AddTrialNuxStoryToOnboardingGroups < ActiveRecord::Migration
  def change
    add_column :onboarding_groups, :trial_nux_story_id, :integer
  end
end
