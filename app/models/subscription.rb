class Subscription < ActiveRecord::Base
  include SoftDeleteModule

  belongs_to :user, class_name: 'Member'

  serialize :discount, Hash

  validates :user, presence: true
  validates :user_id, uniqueness: true
  validates :plan_id,  presence: true
  validates :start, presence: true
  validates :status, presence: true
  validates :customer, presence: true, uniqueness: true
  validates :cancel_at_period_end, :inclusion => {:in => [true, false]}
  validates :current_period_start, presence: true
  validates :current_period_end, presence: true
  validates :quantity, presence: true

  attr_accessible :user, :user_id, :disabled_at

end
