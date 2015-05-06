class ChangeScaleOfDiscounts < ActiveRecord::Migration
  def up
    change_column :discounts, :discount_percent, :decimal, :precision => 2, :scale => 1
  end
end
