FactoryGirl.define do
  factory :scheduled_communication do
    association :sender, factory: :pha
    state 'scheduled'
    publish_at Time.now + 1.day

    factory :scheduled_message, class: ScheduledMessage do
      association :consult, factory: [:consult, :master]
      text 'This is a scheduled message'
    end

    factory :scheduled_template_email, class: ScheduledTemplateEmail do
      association :recipient, factory: :member
      template 'automated_onboarding_survey_email'
    end

    trait :scheduled do
      state 'scheduled'
      publish_at Time.now + 1.day
    end

    trait :held do
      state 'held'
    end

    trait :delivered do
      state 'delivered'
      delivered_at Time.now
    end

    trait :canceled do
      state 'canceled'
    end
  end
end
