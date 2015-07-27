class CreateTaskDataFieldTemplates < ActiveRecord::Migration
  def change
    create_table :task_data_field_templates do |t|
      t.references :task_template
      t.references :data_field_template
      t.integer :ordinal
      t.string :section
      t.timestamps
    end
  end
end
