FactoryGirl.define do
  factory :scheduled_communication do
    association :sender, factory: :pha
    association :recipient, factory: %i(member premium)
    state 'scheduled'
    publish_at Time.now + 1.day

    factory :scheduled_message, class: ScheduledMessage do
      text 'This is a scheduled message'
    end

    factory :scheduled_template_email, class: ScheduledTemplateEmail do
      template 'automated_onboarding_survey_email'
    end

    factory :scheduled_plain_text_email, class: ScheduledPlainTextEmail do
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
  end
end
