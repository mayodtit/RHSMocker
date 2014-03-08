class AddStateToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :state, :string, allow_nil: true
  end
end
