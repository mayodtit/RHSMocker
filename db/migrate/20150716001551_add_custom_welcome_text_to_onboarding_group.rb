class AddCustomWelcomeTextToOnboardingGroup < ActiveRecord::Migration
  def change
    add_column :onboarding_groups, :custom_welcome, :text
  end
end
