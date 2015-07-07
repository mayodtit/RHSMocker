class AddResultsToTaskTemplateSets < ActiveRecord::Migration
  def change
    add_column :task_template_sets, :affirmative_child_id, :integer
    add_column :task_template_sets, :negative_child_id, :integer
  end
end
