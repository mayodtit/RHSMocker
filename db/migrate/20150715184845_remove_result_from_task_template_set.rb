class RemoveResultFromTaskTemplateSet < ActiveRecord::Migration
  def change
    remove_column :task_template_sets, :result
  end
end
