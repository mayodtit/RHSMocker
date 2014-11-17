class AddRelativeHoursToCommunicationWorkflowTemplates < ActiveRecord::Migration
  def change
    add_column :communication_workflow_templates, :relative_hours, :integer
  end
end
