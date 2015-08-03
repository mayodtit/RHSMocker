FactoryGirl.define do
  factory :system_event do
    association :user, factory: :member
    system_event_template
    trigger_at Time.now + 1.day
    state 'scheduled'

    trait :scheduled do
      state 'scheduled'
      trigger_at Time.now + 1.day
    end

    trait :triggered do
      state 'triggered'
      trigger_at Time.now - 1.day
    end

    trait :canceled do
      state 'canceled'
      trigger_at Time.now + 1.day
    end
  end
end
