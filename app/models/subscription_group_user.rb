class SubscriptionGroupUser < ActiveRecord::Base
  belongs_to :subscription_group
  belongs_to :user, class_name: 'Member'

  attr_accessible :subscription_group, :subscription_group_id, :user, :user_id

  validates :subscription_group, :user, presence: true

  after_create :upgrade_user_to_premium
  before_destroy :downgrade_user_from_premium

  private

  def upgrade_user_to_premium
    return if user.is_premium?
    if user.pha.present?
      user.update_attributes!(is_premium: true)
    else
      user.update_attributes!(is_premium: true,
                              pha: subscription_group.owner.pha)
    end
  end

  def downgrade_user_from_premium
    user.update_attributes(is_premium: false)
  end
end
