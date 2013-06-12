class TreatmentSideEffect < ActiveRecord::Base
  belongs_to :treatment
  belongs_to :side_effect

  attr_accessible :treatment, :side_effect
  attr_accessible :treatment_id, :side_effect_id

  validates :treatment, :presence => true
  validates :side_effect, :presence => true
end
