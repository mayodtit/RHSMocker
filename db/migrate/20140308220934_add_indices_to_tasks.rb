class AddIndicesToTasks < ActiveRecord::Migration
  def change
    add_index :tasks, [:state, :due_at, :created_at]
    add_index :tasks, [:state]
    add_index :tasks, [:owner_id, :state]
    add_index :tasks, [:consult_id, :state]
    add_index :tasks, [:consult_id]
  end
end
