FactoryGirl.define do
  factory :association do
    user
    association :associate, factory: :user
    association_type
    state :enabled

    trait :disabled do
      state :disabled
    end
  end
end
