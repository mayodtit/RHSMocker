class ReverseRelationshipForOnboardingMessageTemplates < ActiveRecord::Migration
  def up
    remove_column :message_templates, :onboarding_group_id
    add_column :onboarding_groups, :welcome_message_template_id, :integer
  end

  def down
    remove_column :onboarding_groups, :welcome_message_template_id
    add_column :message_templates, :onboarding_group_id, :integer
  end
end
