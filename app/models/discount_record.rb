class DiscountRecord < ActiveRecord::Base
  belongs_to :user

  attr_accessible :referrer_id, :referee_id, :referral_code_id, :referrer, :redeemed_at

  validates :referee_id, :referral_code_id, presence: true
end