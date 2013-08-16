FactoryGirl.define do
  factory :user_allergy do
    association :user
    association :allergy
  end
end
