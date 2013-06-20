class UserPlan < ActiveRecord::Base
  belongs_to :plan
  belongs_to :user
  attr_accessible :user_id, :plan_id, :cancellation_date
end
