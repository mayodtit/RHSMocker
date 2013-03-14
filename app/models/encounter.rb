class Encounter < ActiveRecord::Base
  attr_accessible :checked, :priority, :status
  
  belongs_to :user
  has_many :encounters_user
  has_many :messages
end
