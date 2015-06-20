class CreateTaskStepTemplates < ActiveRecord::Migration
  def change
    create_table :task_step_templates do |t|
      t.references :task_template
      t.text :description
      t.integer :ordinal
      t.timestamps
    end
  end
end
