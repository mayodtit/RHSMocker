class AddTaskTemplateSetIdToTaskTemplate < ActiveRecord::Migration
  def change
    add_column :task_templates, :task_template_set_id, :integer
  end
end
