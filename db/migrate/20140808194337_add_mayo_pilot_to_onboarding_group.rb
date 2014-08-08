class AddMayoPilotToOnboardingGroup < ActiveRecord::Migration
  def change
    add_column :onboarding_groups, :mayo_pilot, :boolean
  end
end
