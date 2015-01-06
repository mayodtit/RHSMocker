class DiscountRecord < ActiveRecord::Base
  belongs_to :user
  belongs_to :referral_code

  attr_accessible :user_id, :referral_code_id, :referrer, :coupon, :redeemed_at

  validates :user_id, :referral_code_id, presence: true
end
