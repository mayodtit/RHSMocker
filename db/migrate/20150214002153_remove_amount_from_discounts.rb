class RemoveAmountFromDiscounts < ActiveRecord::Migration
  def up
    remove_column :discounts, :amount
  end

  def down
    add_column :discounts, :amount, :integer, :null => false
  end
end
