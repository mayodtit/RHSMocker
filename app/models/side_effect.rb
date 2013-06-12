class SideEffect < ActiveRecord::Base
  has_many :treatment_side_effects
  has_many :treatments, :through => :treatment_side_effects

  attr_accessible :name, :description

  validates :name, :presence => true
end
