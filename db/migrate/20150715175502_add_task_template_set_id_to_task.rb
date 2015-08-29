class AddTaskTemplateSetIdToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :task_template_set_id, :integer
  end
end
