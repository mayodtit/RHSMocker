class UserDiseaseTreatmentTreatmentSideEffect < ActiveRecord::Base
  belongs_to :user_disease_treatment
  belongs_to :treatment_side_effect

  attr_accessible :user_disease_treatment, :treatment_side_effect
  attr_accessible :user_disease_treatment_id, :treatment_side_effect_id

  validates :user_disease_treatment, :presence => true
  validates :treatment_side_effect, :presence => true
end
