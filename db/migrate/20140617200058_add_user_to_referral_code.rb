class AddUserToReferralCode < ActiveRecord::Migration
  def change
    add_column :referral_codes, :user_id, :integer
  end
end
