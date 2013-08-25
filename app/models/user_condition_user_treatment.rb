class UserConditionUserTreatment < ActiveRecord::Base
  belongs_to :user_condition
  belongs_to :user_treatment

  attr_accessible :user_condition, :user_treatment
  attr_accessible :user_condition_id, :user_treatment_id

  validates :user_condition, :user_treatment, presence: true
  validates :user_treatment_id, :uniqueness => {:scope => :user_condition_id}

  alias_attribute :user_disease, :user_condition
  alias_attribute :user_disease_treatment, :user_treatment
  alias_attribute :user_disease_id, :user_condition_id
  alias_attribute :user_disease_treatment_id, :user_treatment_id

  def serializable_hash options=nil
    super(options || {:methods => [:user_disease_id, :user_disease_treatment_id]})
  end
end
