class AddReferenceEventToMessageWorkflowTemplate < ActiveRecord::Migration
  def change
    add_column :communication_workflow_templates, :reference_event, :string
  end
end
