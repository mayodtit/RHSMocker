class ChangeScaleOfDiscounts < ActiveRecord::Migration
  def up
    add_column :discounts, :discount_percent, :decimal, :precision => 2, :scale => 1
  end

  def down
    remove_column :discounts, :discount_percent
  end
end
