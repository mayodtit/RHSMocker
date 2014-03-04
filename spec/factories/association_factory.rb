FactoryGirl.define do
  factory :association do
    association :user, factory: :member
    associate { association(:user, owner: user) }
    creator { user }
    association_type
    state 'enabled'

    trait :pending do
      state 'pending'
    end

    trait :disabled do
      state 'disabled'
    end

    trait :associate_with_email do
      associate { association(:user, owner: user, email: 'test@test.getbetter.com') }
    end

    trait :member_associate do
      association :associate, factory: :member
    end

    after(:build) do |a|
      a.permission ||= build(:permission, subject: a)
    end
  end
end
