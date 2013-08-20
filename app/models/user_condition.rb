class UserCondition < ActiveRecord::Base
  belongs_to :user
  belongs_to :disease
  belongs_to :diagnoser, :class_name => 'User'
  has_many :user_condition_user_treatments
  has_many :user_treatments, :through => :user_condition_user_treatments

  attr_accessible :user, :disease, :diagnoser
  attr_accessible :being_treated, :diagnosed, :diagnosed_date, :end_date, :start_date, :disease_id, :diagnoser_id

  validates :user, :disease, presence: true

  simple_has_many_accessor_for :user_treatments, :user_condition_user_treatments

  def serializable_hash options=nil
    options ||= {:include => :disease, :methods => :user_treatment_ids}
    super(options)
  end
end
