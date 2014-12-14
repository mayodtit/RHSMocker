class AddSubscriptionDaysToOnboardingGroups < ActiveRecord::Migration
  def change
    add_column :onboarding_groups, :subscription_days, :integer, null: false, default: 0
  end
end
