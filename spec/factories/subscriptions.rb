FactoryGirl.define do
  factory :subscription do
    association :owner, factory: [:member, :premium]
  end
end
