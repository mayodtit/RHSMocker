class UserCondition < ActiveRecord::Base
  belongs_to :user
  belongs_to :condition
  belongs_to :diagnoser, :class_name => 'User'
  has_many :user_condition_user_treatments
  has_many :user_treatments, :through => :user_condition_user_treatments

  attr_accessor :actor_id

  attr_accessible :user, :user_id, :condition, :condition_id, :diagnoser, :diagnoser_id, :being_treated,
                  :diagnosed, :diagnosed_date, :start_date, :end_date, :disease, :disease_id,
                  :user_disease_treatment_ids, :actor_id

  validates :user, :condition, presence: true
  validates :condition_id, :uniqueness => {:scope => :user_id}

  alias_attribute :disease, :condition
  alias_attribute :disease_id, :condition_id
  alias_method :user_disease_treatment_ids, :user_treatment_ids
  alias_method :user_disease_treatment_ids=, :user_treatment_ids=

  after_destroy :track_destroy
  after_create :track_create

  simple_has_many_accessor_for :user_treatments, :user_condition_user_treatments

  def track_create
    self.actor_id ||= Member.robot.id
    UserChange.create! user: user, actor_id: actor_id, action: 'add', data: {conditions: [condition.name]}
  end

  def track_destroy
    self.actor_id ||= Member.robot.id
    UserChange.create! user: user, actor_id: actor_id, action: 'destroy', data: {conditions: [condition.name]}
  end
end
