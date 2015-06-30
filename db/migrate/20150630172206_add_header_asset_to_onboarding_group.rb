class AddHeaderAssetToOnboardingGroup < ActiveRecord::Migration
  def change
    add_column :onboarding_groups, :header_asset, :string
  end
end
