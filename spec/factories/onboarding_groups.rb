FactoryGirl.define do
  factory :onboarding_group do
    sequence(:name) {|n| "OnboardingGroup #{n}"}
    premium false
    mayo_pilot false
    skip_automated_communications false

    trait :premium do
      premium true
    end

    trait :mayo_pilot do
      mayo_pilot true
    end
  end
end
