class AddFirstNameToOnboardingGroupCandiate < ActiveRecord::Migration
  def change
    add_column :onboarding_group_candidates, :first_name, :string
  end
end
