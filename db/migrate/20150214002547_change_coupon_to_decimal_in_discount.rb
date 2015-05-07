class ChangeCouponToDecimalInDiscount < ActiveRecord::Migration
  def up
    change_column :discounts, :coupon, :decimal, :null => false
  end

  def down
    change_column :discounts, :coupon, :string, :null => false
  end
end
