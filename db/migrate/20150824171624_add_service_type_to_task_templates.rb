class AddServiceTypeToTaskTemplates < ActiveRecord::Migration
  def change
    add_column :task_templates, :service_type_id, :integer
  end
end
