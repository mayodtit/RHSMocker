FactoryGirl.define do
  factory :subscription_group_user do
    subscription_group
    association :user, factory: :member
  end
end
