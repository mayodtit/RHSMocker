class AddPhaToOnboardingGroups < ActiveRecord::Migration
  def change
    add_column :onboarding_groups, :pha_id, :integer
  end
end
