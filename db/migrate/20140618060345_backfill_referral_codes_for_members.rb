class BackfillReferralCodesForMembers < ActiveRecord::Migration
  def up
    Member.reset_column_information
    Member.find_each do |m|
      m.send(:add_owned_referral_code)
    end
  end

  def down
  end
end
