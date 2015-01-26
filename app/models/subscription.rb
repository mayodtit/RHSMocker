class Subscription < ActiveRecord::Base
  belongs_to :owner, class_name: 'Member'

  attr_accessible :owner, :owner_id, :stripe_subscription_id

  validates :owner, presence: true, if: ->(s){s.owner_id}
end
