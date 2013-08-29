class UserTreatmentSideEffect < ActiveRecord::Base
  belongs_to :user_treatment
  belongs_to :side_effect

  attr_accessible :user_treatment, :side_effect
  attr_accessible :user_treatment_id, :side_effect_id

  validates :user_treatment, :presence => true
  validates :side_effect, :presence => true
  validates :user_treatment_id, :uniqueness => {:scope => :side_effect_id}
end
