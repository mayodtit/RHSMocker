class AddMayoClinicNurseLineAccessToOnboardingGroup < ActiveRecord::Migration
  def change
    add_column :onboarding_groups, :mayo_nurse_line_access, :boolean, default: true, null: false
  end
end
