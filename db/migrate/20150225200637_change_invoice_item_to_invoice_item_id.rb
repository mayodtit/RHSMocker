class ChangeInvoiceItemToInvoiceItemId < ActiveRecord::Migration
  def up
    rename_column :discounts, :invoice_item, :invoice_item_id
  end

  def down
    rename_column :discounts, :invoice_item_id, :invoice_item
  end
end
