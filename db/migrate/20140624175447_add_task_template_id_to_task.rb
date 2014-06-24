class AddTaskTemplateIdToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :task_template_id, :integer
  end
end
