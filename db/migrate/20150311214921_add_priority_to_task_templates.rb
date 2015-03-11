class AddPriorityToTaskTemplates < ActiveRecord::Migration
  def change
    add_column :task_templates, :priority, :integer
  end
end
