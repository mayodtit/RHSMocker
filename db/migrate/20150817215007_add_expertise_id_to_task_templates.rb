class AddExpertiseIdToTaskTemplates < ActiveRecord::Migration
  def change
    add_column :task_templates, :expertise_id, :integer
  end
end
