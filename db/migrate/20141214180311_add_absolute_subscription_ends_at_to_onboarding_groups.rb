class AddAbsoluteSubscriptionEndsAtToOnboardingGroups < ActiveRecord::Migration
  def change
    add_column :onboarding_groups, :absolute_subscription_ends_at, :datetime
  end
end
