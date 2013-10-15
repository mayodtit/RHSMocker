FactoryGirl.define do
  factory :subscription do
    association :user, factory: :member
    association :plan, factory: [:plan, :with_offering]
  end
end
