class UserLocation < ActiveRecord::Base
  attr_accessible :latitude, :longitude, :user
  has_many :messages
  belongs_to :user

  #Validations
  validates :latitude,  :presence => true
  validates :longitude, :presence => true

  def as_json options=nil
    {
      :latitude=>latitude,
      :longitude=>longitude
    }
  end
end
