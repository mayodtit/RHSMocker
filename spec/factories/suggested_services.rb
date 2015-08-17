FactoryGirl.define do
  factory :suggested_service do
    association :user, factory: :member
    service_type
    sequence(:title) {|n| "SuggestedServiceTemplate #{n}"}
    description { "Get started on #{title}" }
    message { "I'd like to start #{title}" }

    trait :with_service_type do
      service_type
      suggested_service_template nil
    end

    trait :with_suggested_service_template do
      suggested_service_template
      service_type nil
      title nil
      description nil
      message nil
    end

    trait :user_facing do
      user_facing true
    end

    trait :unoffered do
      state 'unoffered'
    end

    trait :offered do
      state 'offered'
    end

    trait :accepted do
      state 'accepted'
    end
    trait :rejected do
      state 'rejected'
    end
    trait :expired do
      state 'expired'
    end
  end
end
