class Allergy < ActiveRecord::Base
  include SoftDeleteModule

  attr_accessible :name, :snomed_name, :snomed_code, :food_allergen, :environment_allergen, :medication_allergen
  has_many :user_allergies
  has_many :user, :through=>:user_allergies

  searchable do
    text :name
    text :snomed_name
  end

  def as_json options=nil
    {
      id:id,
      name:name,
      snomed_name:snomed_name,
      snomed_code:snomed_code,
      food_allergen:food_allergen,
      environment_allergen:environment_allergen,
      medication_allergen:medication_allergen
    }
  end
end
