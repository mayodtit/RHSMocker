class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :plan

  attr_accessible :user, :user_id, :plan, :plan_id

  validates :user, :plan, presence: true
  validates :plan_id, :uniqueness => {:scope => :user_id}
end
