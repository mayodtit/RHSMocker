class UserDisease < ActiveRecord::Base
  belongs_to :user
  belongs_to :disease
  belongs_to :diagnoser, :class_name => 'User'
  has_many :user_disease_treatments
  has_many :treatments, :through=>:user_disease_treatments

  attr_accessible :user, :disease, :diagnoser
  attr_accessible :being_treated, :diagnosed, :diagnosed_date, :end_date, :start_date, :disease_id, :diagnoser_id

  validates :diagnoser, :presence => true, :if => :diagnosed?
  validates :diagnosed_date, :presence => true, :if => :diagnosed?

  def as_json options=nil
    {
      :id=>id,
      :being_treated=>being_treated,
      :diagnosed=>diagnosed,
      :diagnoser_id=>diagnoser_id,
      :diagnosed_date=>diagnosed_date,
      :start_date=>start_date,
      :end_date=>end_date,
      :user_disease_treatments=>user_disease_treatments,
      :disease=>disease
    }
  end
end
