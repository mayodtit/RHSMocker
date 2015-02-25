class ChangeCouponToDiscountPercent < ActiveRecord::Migration
  def up
    remove_column :discounts, :coupon
    add_column :discounts, :discount_percent, :decimal, :null => false
  end

  def down
    add_column :discounts, :coupon, :decimal, :null => false
    remove_column :discounts, :discount_percent
  end
end
