class AddTemplateToCommunicationWorkflowTemplates < ActiveRecord::Migration
  def change
    add_column :communication_workflow_templates, :template, :string
  end
end
