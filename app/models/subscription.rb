class Subscription < ActiveRecord::Base
  belongs_to :user, class_name: 'Member'

  attr_accessible :user, :user_id, :stripe_subscription_id

  validates :user, presence: true, if: ->(s){s.user_id}
end
