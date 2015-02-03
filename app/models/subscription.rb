class Subscription < ActiveRecord::Base
  belongs_to :owner, class_name: 'Member'

  serialize :discount, Hash

  validates :owner, presence: true
  validates :owner_id, uniqueness: true
  validates :plan, current_period_end,  presence: true
  validates :start, presence: true
  validates :status, presence: true
  validates :customer, presence: true
  validates :cancel_at_period_end, :inclusion => {:in => [true, false]}
  validates :current_period_start, presence: true
  validates :current_period_end, presence: true
  validates :quantity, presence: true
  validate :owner_is_premium

  private

  def owner_is_premium
    unless owner.try(:is_premium?)
      errors.add(:owner, 'must be premium')
    end
  end
end
