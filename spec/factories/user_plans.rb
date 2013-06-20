FactoryGirl.define do
  factory :user_plan do
    association :user
    association :plan
  end
end
