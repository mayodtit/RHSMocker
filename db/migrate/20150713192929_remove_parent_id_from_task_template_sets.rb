class RemoveParentIdFromTaskTemplateSets < ActiveRecord::Migration
  def up
    remove_column :task_template_sets, :parent_id
  end

  def down
    add_column :task_template_sets, :parent_id, :integer
  end
end
