class SideEffect < ActiveRecord::Base
  has_many :treatment_side_effects
  has_many :treatments, :through => :treatment_side_effects

  has_many :user_disease_treatment_side_effects
  has_many :user_disease_treatments, :through => :user_disease_treatment_side_effects

  attr_accessible :name, :description

  validates :name, :presence => true

  searchable do
    text :name
  end

  def self.for_treatment(treatment)
    treatment_id = treatment.try_method(:id) || treatment
    joins(:treatment_side_effects).where(:treatment_side_effects => {:treatment_id => treatment_id})
  end
end
