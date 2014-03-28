FactoryGirl.define do
  factory :subscription do
    association :user, factory: :member
    association :plan
  end
end
