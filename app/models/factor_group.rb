class FactorGroup < ActiveRecord::Base
  has_many :symptoms_factors

  attr_accessible :name

  validates :name, presence: true
end
