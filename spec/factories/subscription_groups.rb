FactoryGirl.define do
  factory :subscription_group do
    association :owner, factory: [:member, :premium]
  end
end
