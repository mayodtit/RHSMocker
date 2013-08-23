class NurselineRecord < ActiveRecord::Base
  attr_accessible :payload

  validates :payload, presence: true
end
