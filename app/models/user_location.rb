class UserLocation < ActiveRecord::Base
  attr_accessible :lat, :long

	belongs_to :user

	#Validations
	validates :lat,  :presence => true
	validates :long, :presence => true

end
