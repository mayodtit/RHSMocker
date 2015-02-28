class AddSkipInitialMessageToOnboardingGroups < ActiveRecord::Migration
  def change
    add_column :onboarding_groups, :skip_initial_message, :boolean, null: false, default: false
  end
end
