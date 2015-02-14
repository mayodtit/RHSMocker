class ChangeCouponToDecimalInDiscount < ActiveRecord::Migration
  def change
    change_column :discounts, :coupon, :decimal, :null => false
  end
end
