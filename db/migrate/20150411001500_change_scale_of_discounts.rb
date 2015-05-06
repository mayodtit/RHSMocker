class ChangeScaleOfDiscounts < ActiveRecord::Migration
  def change
    change_column :discounts, :discount_percent, :decimal, :precision => 2, :scale => 1
  end
end
