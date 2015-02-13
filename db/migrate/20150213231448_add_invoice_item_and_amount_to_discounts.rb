class AddInvoiceItemAndAmountToDiscounts < ActiveRecord::Migration
  def change
    add_column :discounts, :amount, :integer, :null => false
    add_column :discounts, :invoice_item, :text
  end
end
