class RenameMessageWorkflowTemplatesToCommunicationWorkflowTemplates < ActiveRecord::Migration
  def up
    rename_table :message_workflow_templates, :communication_workflow_templates
  end

  def down
    rename_table :communication_workflow_templates, :message_workflow_templates
  end
end
