class UserDisease < ActiveRecord::Base
  belongs_to :user
  belongs_to :disease
  belongs_to :diagnoser, :class_name => 'User'
  has_many :user_disease_user_treatments
  has_many :user_disease_treatments, :through => :user_disease_user_treatments

  attr_accessible :user, :disease, :diagnoser
  attr_accessible :being_treated, :diagnosed, :diagnosed_date, :end_date, :start_date, :disease_id, :diagnoser_id

  validates :user, :disease, presence: true
  validates :diagnoser, :diagnosed_date, presence: true, if: :diagnosed?

  def serializable_hash options=nil
    options ||= {}
    options.merge!(:include => :disease) do |k, v1, v2|
      v1.is_a?(Array) ? v1 + v2 : [v1] + v2
    end
    super(options)
  end
end
