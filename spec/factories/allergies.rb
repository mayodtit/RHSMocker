FactoryGirl.define do
  factory :allergy do   
    sequence(:name) { |n| "dust #{n}" }
  end
end
