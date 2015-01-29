class ChangeCouponNumberToCouponCount < ActiveRecord::Migration
  def change
    rename_column :users, :coupon_number, :coupon_count
  end
end
