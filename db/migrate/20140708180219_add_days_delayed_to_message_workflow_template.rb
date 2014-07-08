class AddDaysDelayedToMessageWorkflowTemplate < ActiveRecord::Migration
  def change
    add_column :message_workflow_templates, :days_delayed, :integer
  end
end
