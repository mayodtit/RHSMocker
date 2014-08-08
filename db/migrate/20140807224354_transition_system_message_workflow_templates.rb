class TransitionSystemMessageWorkflowTemplates < ActiveRecord::Migration
  def up
    MessageWorkflowTemplate.where(system_message: true).update_all(type: 'SystemMessageWorkflowTemplate')
  end

  def down
  end
end
