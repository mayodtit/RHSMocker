class UserDisease < ActiveRecord::Base
  belongs_to :user
  belongs_to :disease
  belongs_to :diagnoser, :class_name => 'User'
  has_many :user_disease_user_treatments
  has_many :user_disease_treatments, :through => :user_disease_user_treatments

  attr_accessible :user, :disease, :diagnoser
  attr_accessible :being_treated, :diagnosed, :diagnosed_date, :end_date, :start_date, :disease_id, :diagnoser_id,
                  :user_disease_treatment_ids

  validates :user, :disease, presence: true
  validates :diagnoser, :diagnosed_date, presence: true, if: :diagnosed?

  def serializable_hash options=nil
    options ||= {:include => :disease, :methods => :user_disease_treatment_ids}
    super(options)
  end

  def user_disease_treatment_ids
    user_disease_user_treatments.pluck(:user_disease_treatment_id)
  end

  def user_disease_treatment_ids=(ids)
    ids ||= []
    UserDisease.transaction do
      user_disease_user_treatments.destroy_all and return if ids.empty?
      user_disease_user_treatments.where('user_disease_user_treatments.user_disease_treatment_id NOT IN (?)', ids).destroy_all
      ids.each do |id|
        user_disease_treatments << user.user_disease_treatments.find(id) unless user_disease_treatment_ids.include?(id)
      end
    end
  end
end
