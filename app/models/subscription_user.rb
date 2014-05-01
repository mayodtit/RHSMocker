class SubscriptionUser < ActiveRecord::Base
  belongs_to :subscription
  belongs_to :user, class_name: 'Member'

  attr_accessible :subscription, :subscription_id, :user, :user_id

  validates :subscription, :user, presence: true
  validates :user_id, uniqueness: true

  after_create :upgrade_user_to_premium
  before_destroy :downgrade_user_from_premium

  private

  def upgrade_user_to_premium
    return if user.is_premium?
    if user.pha.present?
      user.update_attributes!(is_premium: true)
    else
      user.update_attributes!(is_premium: true,
                              pha: subscription.owner.pha)
    end
  end

  def downgrade_user_from_premium
    user.update_attributes(is_premium: false)
  end
end
