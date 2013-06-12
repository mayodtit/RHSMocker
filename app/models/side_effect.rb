class SideEffect < ActiveRecord::Base
  has_many :treatment_side_effects
  has_many :treatments, :through => :treatment_side_effects

  attr_accessible :name, :description

  validates :name, :presence => true

  def self.for_treatment(treatment)
    treatment_id = treatment.try_method(:id) || treatment
    joins(:treatment_side_effects).where(:treatment_side_effects => {:treatment_id => treatment_id})
  end
end
