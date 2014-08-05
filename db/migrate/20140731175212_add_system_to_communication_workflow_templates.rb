class AddSystemToCommunicationWorkflowTemplates < ActiveRecord::Migration
  def change
    add_column :communication_workflow_templates, :system_message, :boolean
  end
end
