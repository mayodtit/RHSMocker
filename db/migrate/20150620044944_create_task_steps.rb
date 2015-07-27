class CreateTaskSteps < ActiveRecord::Migration
  def change
    create_table :task_steps do |t|
      t.references :task
      t.references :task_step_template
      t.boolean :completed
      t.timestamps
    end
  end
end
