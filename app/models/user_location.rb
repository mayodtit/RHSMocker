class UserLocation < ActiveRecord::Base
  attr_accessible :user, :lat, :long

	belongs_to :user

	#Validations
	validates :user, :presence => true
	validates :lat,  :presence => true
	validates :long, :presence => true

end
