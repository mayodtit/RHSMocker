FactoryGirl.define do
  factory :allergy do
    sequence(:name) { |n| "Allergy #{n}" }
    sequence(:snomed_name) { |n| "Allergy #{n} SNOMED Name" }
    sequence(:snomed_code) { |n| "#{n + 100}" }
    food_allergen { [true, false].sample }
    environment_allergen { [true, false].sample }
    medication_allergen { [true, false].sample }
  end
end
