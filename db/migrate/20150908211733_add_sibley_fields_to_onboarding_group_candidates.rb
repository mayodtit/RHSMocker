class AddSibleyFieldsToOnboardingGroupCandidates < ActiveRecord::Migration
  def change
    add_column :onboarding_group_candidates, :phone, :string
    add_column :onboarding_group_candidates, :surgery_date, :string
    add_column :onboarding_group_candidates, :surgery_time, :string
    add_column :onboarding_group_candidates, :notes, :text
  end
end
