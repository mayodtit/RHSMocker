class RenameDietsOrderToOrdinal < ActiveRecord::Migration
  def up
    rename_column :diets, :order, :ordinal
  end

  def down
    rename_column :diets, :ordinal, :order
  end
end
