class RemoveTaskTemplateSetFromTasks < ActiveRecord::Migration
  def up
    remove_column :tasks, :task_template_set_id
  end

  def down
    add_column :tasks, :task_template_set_id, :integer
  end
end
