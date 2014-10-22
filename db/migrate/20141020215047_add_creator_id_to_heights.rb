class AddCreatorIdToHeights < ActiveRecord::Migration
  def change
    add_column :heights, :creator_id, :integer
  end
end
