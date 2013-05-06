FactoryGirl.define do
  factory :allergy do   
    sequence(:name) { |n| "dust #{n}" }
    sequence(:snomed_name) { |n| "fluffy stuff #{n}" }
    sequence(:snomed_code) { |n| "#{n+100}" }
    food_allergen { [true, false].sample }
    environment_allergen { [true, false].sample }
    medication_allergen { [true, false].sample }
  end
end
