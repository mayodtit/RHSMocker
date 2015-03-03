class Proximity < ActiveRecord::Base
  attr_accessible :city, :zip, :state, :county, :latitude, :longitude
end
