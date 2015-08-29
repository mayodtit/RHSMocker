class AddParentIdToTaskTemplateSet < ActiveRecord::Migration
  def change
    add_column :task_template_sets, :parent_id, :integer
  end
end
