class UserDiseaseUserTreatment < ActiveRecord::Base
  belongs_to :user_disease
  belongs_to :user_treatment

  attr_accessible :user_disease, :user_treatment
  attr_accessible :user_disease_id, :user_treatment_id

  validates :user_disease, :user_treatment, presence: true
  validates :user_treatment_id, :uniqueness => {:scope => :user_disease_id}
end
