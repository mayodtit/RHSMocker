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

    trait :started do
      state 'started'
      association :owner, factory: :member
      association :assignor, factory: :member
      started_at Time.now
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

    trait :abandoned do
      state 'abandoned'
      association :abandoner, factory: :member
      reason 'missed'
      abandoned_at Time.now
    end
  end
end
