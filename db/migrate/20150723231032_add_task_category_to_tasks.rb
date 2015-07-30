class AddTaskCategoryToTasks < ActiveRecord::Migration
  def up
    add_column :tasks, :task_category_id, :integer
  end

  def down
    remove_column :tasks, :task_category_id
  end
end
