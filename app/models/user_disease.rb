class UserDisease < ActiveRecord::Base
  belongs_to :user
  belongs_to :disease
  has_many :user_disease_treatments
  has_many :treatments, :through=>:user_disease_treatments
  attr_accessible :being_treated, :diagnosed, :end_date, :start_date, :user, :disease, :disease_id

  def as_json options=nil
    {
      :id=>id,
      :being_treated=>being_treated,
      :diagnosed=>diagnosed,
      :start_date=>start_date,
      :end_date=>end_date,
      :disease=>disease
    }
  end
end
