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
                  :time_duration_unit, :user_disease_ids

  validates :user, :treatment, presence: true

  def serializable_hash(options=nil)
    options ||= {:include => [:treatment, :side_effects], :methods => :user_disease_ids}
    super(options)
  end

  def user_disease_ids
    user_disease_user_treatments.pluck(:user_disease_id)
  end

  def user_disease_ids=(ids)
    UserDiseaseTreatment.transaction do
      user_disease_user_treatments.destroy_all and return if ids.empty?
      user_disease_user_treatments.where('user_disease_user_treatments.user_disease_id NOT IN (?)', ids).destroy_all
      ids.each do |id|
        user_diseases << user.user_diseases.find(id) unless user_disease_ids.include?(id)
      end
    end
  end
end
