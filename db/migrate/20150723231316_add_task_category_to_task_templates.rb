class AddTaskCategoryToTaskTemplates < ActiveRecord::Migration
  def up
    add_column :task_templates, :task_category_id, :integer
  end

  def down
    remove_column :task_templates, :task_category_id
  end
end
