class AddIndexForMessageTaskValidation < ActiveRecord::Migration
  def change
    add_index :tasks, [:type, :consult_id, :state]
  end
end
