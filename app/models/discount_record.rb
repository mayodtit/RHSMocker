class Discount < ActiveRecord::Base
  belongs_to :member
  belongs_to :referral_code

  attr_accessible :user_id, :referral_code_id, :referrer, :coupon, :redeemed_at

  validates :user, :referral_code, :referrer, :coupon, presence: true
end
