FactoryGirl.define do
  factory :task do
    sequence(:title) { |n| "Plan to do something for the #{n}th time." }
    association :creator, factory: :member
    due_at Time.now

    trait :assigned do
      association :owner, factory: :member
      association :assignor, factory: :member
      assigned_at Time.now
    end

    trait :unclaimed do
      state 'unclaimed'
      unclaimed_at Time.now
    end

    trait :claimed do
      state 'claimed'
      association :owner, factory: :member
      association :assignor, factory: :member
      claimed_at Time.now
    end

    trait :completed do
      state 'completed'
      association :owner, factory: :member
      association :assignor, factory: :member
      completed_at Time.now
    end

    trait :blocked_internal do
      state 'blocked_internal'
      association :owner, factory: :member
      association :assignor, factory: :member
      blocked_internal_at Time.now
    end

    trait :blocked_external do
      state 'blocked_external'
      association :owner, factory: :member
      association :assignor, factory: :member
      blocked_external_at Time.now
    end

    trait :abandoned do
      state 'abandoned'
      association :abandoner, factory: :member
      reason 'missed'
      abandoned_at Time.now
    end
  end
end
