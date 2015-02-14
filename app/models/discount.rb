class Discount < ActiveRecord::Base
  belongs_to :user, class_name: 'Member'
  belongs_to :referral_code

  serialize :invoice_item, Hash

  attr_accessible :user_id, :referral_code_id, :referrer, :coupon, :redeemed_at, :invoice_item

  validates :user, :referral_code, :coupon, presence: true
  validates :referrer, :inclusion => {:in => [true, false]}
end
