class CreateTaskChanges < ActiveRecord::Migration
  def change
    create_table :task_changes do |t|
      t.references :task, null: false
      t.string :event
      t.string :from
      t.string :to
      t.text :data
      t.references :actor, null: false
      t.timestamp :created_at, null: false
    end
    add_index :task_changes, :task_id
  end
end
