class AddIndexToDiscounts < ActiveRecord::Migration
  def change
    add_index :discounts, :user_id
    add_index :discounts, :referral_code_id
  end
end
