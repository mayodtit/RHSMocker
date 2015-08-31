class AddServiceTemplateIdToTaskTemplateSet < ActiveRecord::Migration
  def change
    add_column :task_template_sets, :service_template_id, :integer
  end
end
