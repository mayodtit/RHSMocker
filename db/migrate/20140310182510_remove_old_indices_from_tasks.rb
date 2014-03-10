class RemoveOldIndicesFromTasks < ActiveRecord::Migration
  def change
    remove_index :tasks, [:consult_id]
    remove_index :tasks, [:consult_id, :state]
  end
end
