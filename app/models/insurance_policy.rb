class InsurancePolicy < ActiveRecord::Base
  belongs_to :user

  attr_accessible :user, :user_id, :company_name, :plan_type, :policy_member_id

  validates :user, presence: true
  validates :user_id, uniqueness: true
end
