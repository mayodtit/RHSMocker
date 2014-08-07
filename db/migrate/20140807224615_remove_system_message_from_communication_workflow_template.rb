class RemoveSystemMessageFromCommunicationWorkflowTemplate < ActiveRecord::Migration
  def up
    remove_column :communication_workflow_templates, :system_message
  end

  def down
    add_column :communication_workflow_templates, :system_message, :boolean
  end
end
