class CreateOnboardingGroupCandidates < ActiveRecord::Migration
  def change
    create_table :onboarding_group_candidates do |t|
      t.references :onboarding_group
      t.string :email
      t.timestamps
    end
  end
end
