class AddServiceTypeToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :service_type_id, :integer
  end
end
