class UserDiseaseTreatment < ActiveRecord::Base
  belongs_to :user
  belongs_to :treatment
  belongs_to :doctor, :class_name => 'User'
  has_many :user_disease_user_treatments
  has_many :user_diseases, :through => :user_disease_user_treatments
  has_many :user_disease_treatment_side_effects
  has_many :side_effects, :through => :user_disease_treatment_side_effects

  attr_accessible :user, :treatment, :doctor
  attr_accessible :user_id, :treatment_id, :amount, :amount_unit, :doctor_id, :end_date,
                  :prescribed_by_doctor, :side_effect, :start_date, :successful, :time_duration,
                  :time_duration_unit, :user_disease_ids, :user_disease_user_treatment_attributes

  validates :user, :treatment, presence: true

  accepts_nested_attributes_for :user_disease_user_treatments, allow_destroy: true

  def serializable_hash(options=nil)
    options ||= {:include => [:treatment, :side_effects], :methods => :user_disease_ids}
    super(options)
  end

  def user_disease_ids
    user_disease_user_treatments.pluck(:user_disease_id)
  end

  def user_disease_ids=(ids)
    ids ||= []
    ids = ids.reject{|id| user_disease_ids.include?(id)}
    self.user_disease_user_treatments_attributes = removed_diseases(ids) +
                                                   ids.map{|id| {user_disease_id: id, user_disease_treatment: self}}
  end

  private

  def removed_diseases(ids)
    user_disease_user_treatments.reject{|dt| ids.include?(dt.user_disease_id)}
                                .map{|dt| {id: dt.id, _destroy: true}}
  end
end
