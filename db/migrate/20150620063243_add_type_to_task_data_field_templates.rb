class AddTypeToTaskDataFieldTemplates < ActiveRecord::Migration
  def change
    add_column :task_data_field_templates, :type, :string
  end
end
