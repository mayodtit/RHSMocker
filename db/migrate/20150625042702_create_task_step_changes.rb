class CreateTaskStepChanges < ActiveRecord::Migration
  def change
    create_table :task_step_changes do |t|
      t.references :task_step
      t.references :actor
      t.text :data
      t.timestamps
    end
  end
end
