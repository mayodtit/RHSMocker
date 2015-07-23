FactoryGirl.define do
  factory :onboarding_group_candidate do
    onboarding_group
    sequence(:email) {|n| "test+#{n}@getbetter.com"}
  end
end
