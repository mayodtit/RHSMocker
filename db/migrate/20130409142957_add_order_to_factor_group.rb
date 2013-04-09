class AddOrderToFactorGroup < ActiveRecord::Migration
  def change
    add_column :factor_groups, :order, :integer
  end
end
