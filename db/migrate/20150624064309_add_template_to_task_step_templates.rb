class AddTemplateToTaskStepTemplates < ActiveRecord::Migration
  def change
    add_column :task_step_templates, :template, :text
  end
end
