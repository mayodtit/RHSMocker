class AddProviderIdToOnboardingGroup < ActiveRecord::Migration
  def change
    add_column :onboarding_groups, :provider_id, :integer
  end
end
