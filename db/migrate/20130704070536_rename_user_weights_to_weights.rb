class RenameUserWeightsToWeights < ActiveRecord::Migration
  def up
    rename_table :user_weights, :weights
  end

  def down
    rename_table :weights, :user_weights
  end
end
