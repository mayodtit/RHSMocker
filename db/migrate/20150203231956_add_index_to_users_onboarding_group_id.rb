class AddIndexToUsersOnboardingGroupId < ActiveRecord::Migration
  def change
    add_index :users, :onboarding_group_id
  end
end
