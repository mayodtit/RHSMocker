class AddReferralCodeToMember < ActiveRecord::Migration
  def change
    add_column :users, :referral_code_id, :integer
  end
end
