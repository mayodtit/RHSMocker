FactoryGirl.define do
  factory :subscription_user do
    subscription
    association :user, factory: :member
  end
end
