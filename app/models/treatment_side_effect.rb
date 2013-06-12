class TreatmentSideEffect < ActiveRecord::Base
  belongs_to :treatment
  belongs_to :side_effect

  has_many :user_disease_treatment_treatment_side_effects
  has_many :user_disease_treatments, :through => :user_disease_treatment_treatment_side_effects

  attr_accessible :treatment, :side_effect
  attr_accessible :treatment_id, :side_effect_id

  validates :treatment, :presence => true
  validates :side_effect, :presence => true

  delegate :name, :description, :to => :side_effect

  def as_json
    {
      id: id,
      name: name,
      description: description
    }
  end
end
