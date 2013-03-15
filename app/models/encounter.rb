class Encounter < ActiveRecord::Base
  attr_accessible :checked, :priority, :status
  
  has_many :encounters_users
  has_many :messages
  has_many :users, :through=> :encounters_users
end
