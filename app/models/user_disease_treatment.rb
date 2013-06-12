class UserDiseaseTreatment < ActiveRecord::Base
  belongs_to :user_disease
  belongs_to :treatment
  belongs_to :user
  attr_accessible :amount, :amount_unit, :doctor_user_id, :end_date, :prescribed_by_doctor, :side_effect, :start_date, :successful, :time_duration, :time_duration_unit, :user, :treatment_id, :user_disease_id

  def as_json options=nil
    {treatment:treatment}
  end
end
