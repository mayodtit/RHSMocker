class AddOnboardingGroupIdToMessageTemplates < ActiveRecord::Migration
  def change
    add_column :message_templates, :onboarding_group_id, :integer
  end
end
