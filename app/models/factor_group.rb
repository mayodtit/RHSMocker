class FactorGroup < ActiveRecord::Base
  attr_accessible :name, :order
  has_many :symptoms_factors

end
