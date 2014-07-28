class RenameCommunicationWorkflowTemplatesMessageWorkflowId < ActiveRecord::Migration
  def up
    rename_column :communication_workflow_templates, :message_workflow_id, :communication_workflow_id
  end

  def down
    rename_column :communication_workflow_templates, :communication_workflow_id, :message_workflow_id
  end
end
