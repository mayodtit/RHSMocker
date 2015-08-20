class AddExpertiseIdToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :expertise_id, :integer
  end
end
