class AddReasonToTaskChange < ActiveRecord::Migration
  def change
    add_column :task_changes, :reason, :string
  end
end
