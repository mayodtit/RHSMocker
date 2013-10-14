class Metadata < ActiveRecord::Base
  attr_accessible :key, :value

  validates :key, :value, presence: true
  validates :key, uniqueness: true
end
