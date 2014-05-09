FactoryGirl.define do
  factory :onboarding_group do
    sequence(:name) {|n| "OnboardingGroup #{n}"}
    premium false

    trait :premium do
      premium true
    end
  end
end
