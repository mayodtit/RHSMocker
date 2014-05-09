class AddOnboardingGroupToMembers < ActiveRecord::Migration
  def change
    add_column :users, :onboarding_group_id, :integer
  end
end
