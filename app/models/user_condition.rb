class UserCondition < ActiveRecord::Base
  belongs_to :user
  belongs_to :condition
  belongs_to :diagnoser, :class_name => 'User'
  has_many :user_condition_user_treatments
  has_many :user_treatments, :through => :user_condition_user_treatments

  attr_accessible :user, :condition, :diagnoser
  attr_accessible :being_treated, :diagnosed, :diagnosed_date, :end_date, :start_date, :condition_id, :diagnoser_id

  validates :user, :condition, presence: true

  simple_has_many_accessor_for :user_treatments, :user_condition_user_treatments

  def serializable_hash options=nil
    options ||= {:include => :condition, :methods => :user_treatment_ids}
    super(options)
  end
end
