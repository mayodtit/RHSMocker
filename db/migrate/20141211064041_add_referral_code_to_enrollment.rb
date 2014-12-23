class AddReferralCodeToEnrollment < ActiveRecord::Migration
  def change
    add_column :enrollments, :referral_code_id, :integer
  end
end
