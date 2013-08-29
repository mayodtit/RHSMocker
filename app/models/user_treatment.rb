class UserTreatment < ActiveRecord::Base
  belongs_to :user
  belongs_to :treatment
  belongs_to :doctor, :class_name => 'User'
  has_many :user_condition_user_treatments
  has_many :user_conditions, :through => :user_condition_user_treatments
  has_many :user_treatment_side_effects
  has_many :side_effects, :through => :user_treatment_side_effects

  attr_accessible :user, :treatment, :doctor
  attr_accessible :user_id, :treatment_id, :amount, :amount_unit, :doctor_id, :end_date,
                  :prescribed_by_doctor, :side_effect, :start_date, :successful, :time_duration,
                  :time_duration_unit, :user_disease_ids

  validates :user, :treatment, presence: true

  alias_method :user_disease_ids, :user_condition_ids
  alias_method :user_disease_ids=, :user_condition_ids=

  simple_has_many_accessor_for :user_conditions, :user_condition_user_treatments

  def serializable_hash(options=nil)
    options ||= {:include => [:treatment, :side_effects], :methods => [:user_condition_ids, :user_disease_ids]}
    super(options)
  end
end
