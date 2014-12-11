class AddStripeCouponCodeToOnboardingGroups < ActiveRecord::Migration
  def change
    add_column :onboarding_groups, :stripe_coupon_code, :string
  end
end
