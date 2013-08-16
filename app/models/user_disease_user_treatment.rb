class UserDiseaseUserTreatment < ActiveRecord::Base
  belongs_to :user_disease
  belongs_to :user_disease_treatment

  attr_accessible :user_disease, :user_disease_treatment
  attr_accessible :user_disease_id, :user_disease_treatment_id

  validates :user_disease, :user_disease_treatment, presence: true
  validates :user_disease_treatment_id, :uniqueness => {:scope => :user_disease_id}
end
