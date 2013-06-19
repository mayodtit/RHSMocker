class UserPlan < ActiveRecord::Base
  belongs_to :plan
  belongs_to :user
  attr_accessible :cancellation_date
  # attr_accessible :title, :body
end
