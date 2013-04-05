class FactorGroup < ActiveRecord::Base
  attr_accessible :name
  has_many :symptoms_factors
end
