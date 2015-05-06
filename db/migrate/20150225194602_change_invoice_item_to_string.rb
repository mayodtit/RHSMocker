class ChangeInvoiceItemToString < ActiveRecord::Migration
  def up
    change_column :discounts, :invoice_item, :string
  end

  def down
    change_column :discounts, :invoice_item, :text
  end
end
