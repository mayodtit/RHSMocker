FactoryGirl.define do
  factory :scheduled_communication do
    association :recipient, factory: %i(member premium)
    state 'scheduled'
    publish_at Time.now + 1.day

    factory :scheduled_message, class: ScheduledMessage do
      association :sender, factory: :pha
      text 'This is a scheduled message'
    end

    factory :scheduled_system_message, class: ScheduledSystemMessage do
      text 'This is a scheduled system message'
    end

    factory :scheduled_template_email, class: ScheduledTemplateEmail do
      association :sender, factory: :pha
      template 'automated_onboarding_survey_email'
    end

    factory :scheduled_plain_text_email, class: ScheduledPlainTextEmail do
      association :sender, factory: :pha
      subject 'subject of the email'
      text 'body of the email'
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

    trait :failed do
      state 'failed'
    end

    trait :with_reference do
      reference { recipient }
      reference_event :free_trial_ends_at
      relative_days 0
    end
  end
end
