FactoryGirl.define do
  factory :association do
    ignore do
      skip_permission false
    end

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

    trait :skip_permission do
      ignore do
        skip_permission true
      end
    end

    after(:build) do |model, evaluator|
      unless evaluator.skip_permission
        model.permission ||= build(:permission, subject: model)
      end
    end
  end
end
