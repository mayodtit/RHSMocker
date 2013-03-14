class EncountersUser < ActiveRecord::Base
  belongs_to :encounter
  belongs_to :user
  attr_accessible :role
end
