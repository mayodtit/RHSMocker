class Proximity < ActiveRecord::Base
  self.table_name = "proximity"
  attr_accessible :city, :zip, :state, :county, :latitude, :longitude
end
