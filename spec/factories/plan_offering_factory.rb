FactoryGirl.define do
  factory :plan_offering do
    plan
    offering
    amount 1
    unlimited false
  end
end
