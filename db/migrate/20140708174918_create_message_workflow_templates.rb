class CreateMessageWorkflowTemplates < ActiveRecord::Migration
  def change
    create_table :message_workflow_templates do |t|
      t.references :message_workflow
      t.references :message_template
      t.timestamps
    end
  end
end
