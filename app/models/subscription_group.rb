class SubscriptionGroup < ActiveRecord::Base
  belongs_to :owner, class_name: 'Member'

  validates :owner, presence: true
  validate :owner_is_premium

  private

  def owner_is_premium
    unless owner.try(:is_premium?)
      errors.add(:owner, 'must be premium')
    end
  end
end