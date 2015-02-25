class AddInvoiceItemAndAmountToDiscounts < ActiveRecord::Migration
  def up
    add_column :discounts, :amount, :integer, :null => false
    add_column :discounts, :invoice_item, :text
  end

  def down
    remove_column :discounts, :amount
    remove_column :discounts, :invoice_item
  end
end
