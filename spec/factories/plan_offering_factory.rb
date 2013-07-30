FactoryGirl.define do
  factory :plan_offering do
    association :plan
    association :offering
  end
end
