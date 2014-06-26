class AddServiceIdAndServiceOrdinalToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :service_id, :integer
    add_column :tasks, :service_ordinal, :integer
  end
end
