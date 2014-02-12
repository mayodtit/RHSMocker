FactoryGirl.define do
  factory :association do
    association :user, factory: :member
    association :associate, factory: :user
    association_type
    state :enabled

    trait :pending do
      state :pending
    end

    trait :disabled do
      state :disabled
    end

    trait :member_associate do
      association :associate, factory: :member
    end
  end
end
