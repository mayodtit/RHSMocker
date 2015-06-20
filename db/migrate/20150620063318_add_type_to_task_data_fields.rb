class AddTypeToTaskDataFields < ActiveRecord::Migration
  def change
    add_column :task_data_fields, :type, :string
  end
end
