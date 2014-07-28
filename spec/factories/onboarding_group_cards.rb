FactoryGirl.define do
  factory :onboarding_group_card do
    onboarding_group
    association :resource, factory: :content
    priority 0
  end
end
