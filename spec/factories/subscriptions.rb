FactoryGirl.define do
  factory :subscription do
    association :user, factory: [:member, :premium]
  end
end
