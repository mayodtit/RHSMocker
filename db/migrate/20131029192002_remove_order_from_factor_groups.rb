class RemoveOrderFromFactorGroups < ActiveRecord::Migration
  def up
    remove_column :factor_groups, :order
  end

  def down
    add_column :factor_groups, :order, :integer
  end
end
