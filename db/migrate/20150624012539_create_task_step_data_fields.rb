class CreateTaskStepDataFields < ActiveRecord::Migration
  def change
    create_table :task_step_data_fields do |t|
      t.references :task_step
      t.references :task_data_field
      t.references :task_step_data_field_template
      t.timestamps
    end
  end
end
