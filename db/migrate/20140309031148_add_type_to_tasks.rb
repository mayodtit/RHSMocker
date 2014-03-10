class AddTypeToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :type, :string
  end
end
