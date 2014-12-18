class InsurancePolicy < ActiveRecord::Base
  belongs_to :user

  attr_accessible :user, :user_id, :company_name, :plan_type,
                  :policy_member_id, :notes

  validates :user, presence: true
end
