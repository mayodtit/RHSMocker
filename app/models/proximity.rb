class Proximity < ActiveRecord::Base
  set_table_name "Proximity"
  attr_accessible :city, :zip, :state, :county, :latitude, :longitude

  validates :zip, uniqueness: true
end
