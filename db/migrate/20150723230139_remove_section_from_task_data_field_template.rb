class RemoveSectionFromTaskDataFieldTemplate < ActiveRecord::Migration
  def up
    remove_column :task_data_field_templates, :section
  end

  def down
    add_column :task_data_field_templates, :section, :string
  end
end
