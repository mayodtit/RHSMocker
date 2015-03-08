class AddSkipEmailsToOnboardingGroups < ActiveRecord::Migration
  def change
    add_column :onboarding_groups, :skip_emails, :boolean, null: false, default: false
  end
end
