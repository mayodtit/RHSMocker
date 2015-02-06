class CreateDiscountRecords < ActiveRecord::Migration
  def change
    create_table :discounts do |t|
      t.integer :referral_code_id, :null => false
      t.integer :user_id, :null => false
      t.string :coupon, :null => false
      t.boolean :referrer, :null => false
      t.datetime :redeemed_at
      t.timestamps
    end
  end
end
