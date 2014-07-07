FactoryGirl.define do
  factory :scheduled_message do
    association :sender, factory: :pha
    association :consult, factory: [:consult, :master]
    text 'This is a scheduled message'
    state 'scheduled'
    publish_at Time.now + 1.day

    trait :scheduled do
      state 'scheduled'
      publish_at Time.now + 1.day
    end

    trait :held do
      state 'held'
    end

    trait :sent do
      state 'sent'
      sent_at Time.now
    end

    trait :canceled do
      state 'canceled'
    end
  end
end
