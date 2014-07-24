class RenameMessageWorkflowToCommunicationWorkflow < ActiveRecord::Migration
  def up
    rename_table :message_workflows, :communication_workflows
  end

  def down
    rename_table :communication_workflows, :message_workflows
  end
end
