class AddOrderToEthnicGroups < ActiveRecord::Migration
  def change
    add_column :ethnic_groups, :order, :integer
  end
end
