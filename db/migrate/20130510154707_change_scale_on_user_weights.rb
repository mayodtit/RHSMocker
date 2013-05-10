class ChangeScaleOnUserWeights < ActiveRecord::Migration
  def change
    change_column :user_weights, :weight, :decimal, :precision => 9, :scale => 5, :default => 0
    change_column :user_weights, :bmi, :decimal, :precision => 8, :scale => 5, :default => 0
  end
end
