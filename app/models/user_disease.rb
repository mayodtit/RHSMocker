class UserDisease < ActiveRecord::Base
  belongs_to :user
  belongs_to :disease
  attr_accessible :being_treated, :diagnosed, :end_date, :start_date
end
