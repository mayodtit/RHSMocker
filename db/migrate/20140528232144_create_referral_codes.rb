class CreateReferralCodes < ActiveRecord::Migration
  def change
    create_table :referral_codes do |t|
      t.string :name
      t.string :code
      t.references :creator
      t.references :onboarding_group
      t.timestamps
    end
  end
end
