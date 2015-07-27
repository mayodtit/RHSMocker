class CreateTaskStepDataFieldTemplates < ActiveRecord::Migration
  def change
    create_table :task_step_data_field_templates do |t|
      t.references :task_step_template
      t.references :task_data_field_template
      t.integer :ordinal
      t.timestamps
    end
  end
end
