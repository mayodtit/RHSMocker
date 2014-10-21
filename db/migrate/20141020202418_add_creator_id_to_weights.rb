class AddCreatorIdToWeights < ActiveRecord::Migration
  def change
    add_column :weights, :creator_id, :integer
  end
end
