class RemoveOrdinalFromTaskDataFieldTemplates < ActiveRecord::Migration
  def up
    remove_column :task_data_field_templates, :ordinal
  end

  def down
    add_column :task_data_field_templates, :ordinal, :integer
  end
end
