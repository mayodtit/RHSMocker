class ChangeCouponToDiscountPercent < ActiveRecord::Migration
  def change
    remove_column :discounts, :coupon
    add_column :discounts, :discount_percent, :decimal, :null => false
  end
end
