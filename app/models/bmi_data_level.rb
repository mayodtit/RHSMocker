class BmiDataLevel < ActiveRecord::Base
  attr_accessible :age_in_months, :gender, :power_in_transformation, :median, :coefficient_of_variation
  validates :age_in_months, :gender, :power_in_transformation, :median, :coefficient_of_variation, presence: true
end
