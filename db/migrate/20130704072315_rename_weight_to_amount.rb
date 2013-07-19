class RenameWeightToAmount < ActiveRecord::Migration
  def up
    rename_column :weights, :weight, :amount
  end

  def down
    rename_column :weights, :amount, :weight
  end
end
