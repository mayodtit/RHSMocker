class AddTypeToCommunicationWorkflowTemplate < ActiveRecord::Migration
  def change
    add_column :communication_workflow_templates, :type, :string
  end
end
