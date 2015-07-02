class AddBackgroundAssetToOnboardingGroup < ActiveRecord::Migration
  def change
    add_column :onboarding_groups, :background_asset, :string
  end
end
