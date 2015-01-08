class AddTimeEstimateToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :time_estimate, :integer
  end
end
