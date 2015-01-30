class Discount < ActiveRecord::Base
  belongs_to :user, class_name: 'Member'
  belongs_to :referral_code

  attr_accessible :user_id, :referral_code_id, :referrer, :coupon, :redeemed_at

  validates :user, :referral_code, :coupon, presence: true
  validates :referrer, :inclusion => {:in => [true, false]}
end
