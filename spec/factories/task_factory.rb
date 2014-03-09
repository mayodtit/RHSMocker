FactoryGirl.define do
  factory :task do
    title { |n| "Plan to do something for the #{n}th time." }
    association :creator, factory: :member

    trait :assigned do
      state 'assigned'
      association :owner, factory: :member
      association :assignor, factory: :member
      assigned_at Time.now
    end

    trait :started do
      state 'started'
      association :owner, factory: :member
      started_at Time.now
    end

    trait :claimed do
      state 'claimed'
      association :owner, factory: :member
      claimed_at Time.now
    end

    trait :completed do
      state 'completed'
      association :owner, factory: :member
      completed_at Time.now
    end

    trait :abandoned do
      state 'abandoned'
      association :owner, factory: :member
      association :abandoner, factory: :member
      reason_abandoned 'missed'
      abandoned_at Time.now
    end
  end
end
