class AddKindToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :kind, :string, allow_nil: false
  end
end
