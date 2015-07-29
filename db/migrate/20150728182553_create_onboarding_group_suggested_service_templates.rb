class CreateOnboardingGroupSuggestedServiceTemplates < ActiveRecord::Migration
  def change
    create_table :onboarding_group_suggested_service_templates do |t|
      t.references :onboarding_group
      t.references :suggested_service_template
      t.timestamps
    end
  end
end
