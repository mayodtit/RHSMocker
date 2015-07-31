class AddDetailsToTaskStepTemplates < ActiveRecord::Migration
  def change
    add_column :task_step_templates, :details, :text
  end
end
