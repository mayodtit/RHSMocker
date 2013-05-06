FactoryGirl.define do
  factory :allergy do   
    sequence(:name) { |n| "dust #{n}" }
    sequence(:snomed_name) { |n| "fluffy stuff #{n}" }
    sequence(:snomed_code) { |n| "#{n+100}" }

  end
end
