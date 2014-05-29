FactoryGirl.define do
  factory :referral_code do
    association :creator, factory: :member
    sequence(:code) {|n| "Code#{n}"}

    trait :with_onboarding_group do
      onboarding_group
    end
  end
end
