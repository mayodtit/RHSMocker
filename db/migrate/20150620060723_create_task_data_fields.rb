class CreateTaskDataFields < ActiveRecord::Migration
  def change
    create_table :task_data_fields do |t|
      t.references :task
      t.references :data_field
      t.references :task_data_field_template
      t.timestamps
    end
  end
end
