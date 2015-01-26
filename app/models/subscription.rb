class Subscription < ActiveRecord::Base
  include SoftDeleteModule

  belongs_to :user, class_name: 'Member'

  attr_accessible :user, :user_id, :stripe_subscription_id, :disabled_at

  validates :user, presence: true, if: ->(s){s.user_id}
end
