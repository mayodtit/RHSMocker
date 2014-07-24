class BackfillTypeForCommunicationWorkflowTemplates < ActiveRecord::Migration
  def up
    CommunicationWorkflowTemplate.reset_column_information
    CommunicationWorkflowTemplate.update_all(type: 'MessageWorkflowTemplate')
  end

  def down
  end
end
