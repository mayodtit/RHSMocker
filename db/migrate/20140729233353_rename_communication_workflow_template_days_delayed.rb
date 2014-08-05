class RenameCommunicationWorkflowTemplateDaysDelayed < ActiveRecord::Migration
  def up
    rename_column :communication_workflow_templates, :days_delayed, :relative_days
  end

  def down
    rename_column :communication_workflow_templates, :relative_days, :days_delayed
  end
end
