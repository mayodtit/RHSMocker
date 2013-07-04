class ChangeEthnicGroupOrderToOrdinal < ActiveRecord::Migration
  def up
    rename_column :ethnic_groups, :order, :ordinal
  end

  def down
    rename_column :ethnic_groups, :ordinal, :order
  end
end
