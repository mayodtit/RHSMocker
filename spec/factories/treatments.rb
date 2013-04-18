FactoryGirl.define do
  factory :treatment do   
    sequence(:name) { |n| "penicillin #{n}" }
  end
end
