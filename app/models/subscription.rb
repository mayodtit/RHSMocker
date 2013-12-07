class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :plan

  attr_accessible :user, :user_id, :plan, :plan_id

  validates :user, :plan, presence: true
  validates :plan_id, :uniqueness => {:scope => :user_id}

  after_create :add_credits_to_user!

  private

  def add_credits_to_user!
    plan.plan_offerings.each do |po|
      po.add_credits!(user)
    end
    true
  end
end
