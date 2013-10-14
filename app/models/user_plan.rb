class UserPlan < ActiveRecord::Base
  belongs_to :user
  belongs_to :plan

  attr_accessible :user, :plan
  attr_accessible :user_id, :plan_id, :cancellation_date

  after_create :add_plan_offerings_to_user!

  private

  def add_plan_offerings_to_user!
    plan.plan_offerings.each do |po|
      if po.unlimited?
        user.credits.create!(offering_id: po.offering_id, unlimited: true)
      else
        po.amount.times do
          user.credits.create!(offering_id: po.offering_id)
        end
      end
    end
    true
  end
end
