class RemoveKindFromTasks < ActiveRecord::Migration
  def up
    remove_column :tasks, :kind
  end

  def down
    add_column :tasks, :kind, :string
  end
end
