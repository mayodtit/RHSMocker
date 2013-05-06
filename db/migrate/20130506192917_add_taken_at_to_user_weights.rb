class AddTakenAtToUserWeights < ActiveRecord::Migration
  def change
    add_column :user_weights, :taken_at, :datetime
  end
end
