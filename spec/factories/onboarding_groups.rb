FactoryGirl.define do
  factory :onboarding_group do
    sequence(:name) {|n| "OnboardingGroup #{n}"}
    premium false
  end
end
