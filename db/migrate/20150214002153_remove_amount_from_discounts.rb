class RemoveAmountFromDiscounts < ActiveRecord::Migration
  def change
    remove_column :discounts, :amount
  end
end
