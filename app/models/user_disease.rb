class UserDisease < ActiveRecord::Base
  belongs_to :user
  belongs_to :disease
  belongs_to :diagnoser, :class_name => 'User'
  has_many :user_disease_user_treatments
  has_many :user_disease_treatments, :through => :user_disease_user_treatments

  attr_accessible :user, :disease, :diagnoser
  attr_accessible :being_treated, :diagnosed, :diagnosed_date, :end_date, :start_date, :disease_id, :diagnoser_id,
                  :user_disease_treatment_ids, :user_disease_user_treatment_attributes

  validates :user, :disease, presence: true
  validates :diagnoser, :diagnosed_date, presence: true, if: :diagnosed?

  accepts_nested_attributes_for :user_disease_user_treatments, allow_destroy: true

  def serializable_hash options=nil
    options ||= {:include => :disease, :methods => :user_disease_treatment_ids}
    super(options)
  end

  def user_disease_treatment_ids
    user_disease_user_treatments.pluck(:user_disease_treatment_id)
  end

  def user_disease_treatment_ids=(ids)
    ids ||= []
    ids = ids.reject{|id| user_disease_treatment_ids.include?(id)}
    self.user_disease_user_treatments_attributes = removed_treatments(ids) +
                                                   ids.map{|id| {user_disease_treatment_id: id, user_disease: self}}
  end

  private

  def removed_treatments(ids)
    user_disease_user_treatments.reject{|dt| ids.include?(dt.user_disease_treatment_id)}
                                .map{|dt| {id: dt.id, _destroy: true}}
  end
end
