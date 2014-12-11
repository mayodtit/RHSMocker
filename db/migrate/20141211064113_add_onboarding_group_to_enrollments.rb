class AddOnboardingGroupToEnrollments < ActiveRecord::Migration
  def change
    add_column :enrollments, :onboarding_group_id, :integer
  end
end
