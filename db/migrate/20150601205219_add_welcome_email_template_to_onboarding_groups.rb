class AddWelcomeEmailTemplateToOnboardingGroups < ActiveRecord::Migration
  def change
    add_column :onboarding_groups, :welcome_email_template, :string
  end
end
