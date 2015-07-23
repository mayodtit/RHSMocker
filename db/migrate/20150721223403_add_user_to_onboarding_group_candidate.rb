class AddUserToOnboardingGroupCandidate < ActiveRecord::Migration
  def change
    add_column :onboarding_group_candidates, :user_id, :integer
  end
end
