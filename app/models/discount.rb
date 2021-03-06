class Discount < ActiveRecord::Base
  belongs_to :user, class_name: 'Member'
  belongs_to :referral_code

  attr_accessible :user_id, :referral_code_id, :referrer, :discount_percent, :redeemed_at, :invoice_item_id, :referee_id

  validates :user, :referral_code, :discount_percent, presence: true
  validates :referrer, :inclusion => {:in => [true, false]}
end
