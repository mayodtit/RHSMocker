class Location < ActiveRecord::Base
  belongs_to :user
  has_many :messages

  attr_accessible :user, :latitude, :longitude

  validates :user, :latitude, :longitude, presence: true
end
