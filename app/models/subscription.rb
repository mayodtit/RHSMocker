class Subscription < ActiveRecord::Base

  belongs_to :user, class_name: 'Member'

  serialize :discount, Hash
  serialize :metadata, Hash
  serialize :plan, Hash

  validates :user, presence: true
  validates :plan,  presence: true
  validates :status, presence: true
  validates :customer, presence: true
  validates :cancel_at_period_end, :inclusion => {:in => [true, false]}
  validates :current, :inclusion => {:in => [true, false]}
  validates :quantity, presence: true

  attr_accessible :user, :user_id, :start, :status, :customer, :cancel_at_period_end, :current_period_end, :discount,
                  :current_period_start, :ended_at, :trial_start, :trial_end, :quantity, :plan, :metadata, :tax_percent,
                  :application_fee_percent, :stripe_subscription_id, :current

end
