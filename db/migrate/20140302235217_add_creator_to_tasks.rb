class AddCreatorToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :creator_id, :integer
  end
end
