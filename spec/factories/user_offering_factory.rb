FactoryGirl.define do
  factory :user_offering do
    association :user
    association :offering
  end
end
