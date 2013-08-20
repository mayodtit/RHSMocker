class UserConditionUserTreatment < ActiveRecord::Base
  belongs_to :user_condition
  belongs_to :user_treatment

  attr_accessible :user_condition, :user_treatment
  attr_accessible :user_condition_id, :user_treatment_id

  validates :user_condition, :user_treatment, presence: true
  validates :user_treatment_id, :uniqueness => {:scope => :user_condition_id}
end
