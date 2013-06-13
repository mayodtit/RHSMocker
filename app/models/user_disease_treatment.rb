class UserDiseaseTreatment < ActiveRecord::Base
  belongs_to :user
  belongs_to :treatment
  belongs_to :user_disease

  has_many :user_disease_treatment_treatment_side_effects
  has_many :treatment_side_effects, :through => :user_disease_treatment_treatment_side_effects

  attr_accessible :user, :treatment, :user_disease
  attr_accessible :user_id, :treatment_id, :user_disease_id, :amount, :amount_unit, :doctor_user_id,
                  :end_date, :prescribed_by_doctor, :side_effect, :start_date, :successful, :time_duration,
                  :time_duration_unit

  def as_json options=nil
    super.merge({treatment: treatment.as_json,
                 treatment_side_effects: treatment_side_effects.as_json})
  end
end
