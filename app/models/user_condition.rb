class UserCondition < ActiveRecord::Base
  belongs_to :user
  belongs_to :condition
  belongs_to :diagnoser, :class_name => 'User'
  has_many :user_condition_user_treatments
  has_many :user_treatments, :through => :user_condition_user_treatments

  attr_accessible :user, :user_id, :condition, :condition_id, :diagnoser, :diagnoser_id, :being_treated,
                  :diagnosed, :diagnosed_date, :start_date, :end_date, :disease, :disease_id,
                  :user_disease_treatment_ids

  validates :user, :condition, presence: true

  alias_attribute :disease, :condition
  alias_attribute :disease_id, :condition_id
  alias_method :user_disease_treatment_ids, :user_treatment_ids
  alias_method :user_disease_treatment_ids=, :user_treatment_ids=

  simple_has_many_accessor_for :user_treatments, :user_condition_user_treatments

  def serializable_hash options=nil
    options ||= {:include => [:condition, :disease], :methods => [:user_treatment_ids, :disease_id]}
    super(options)
  end
end
