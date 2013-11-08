FactoryGirl.define do
  factory :card do
    user
    association :resource, factory: :content

    trait :saved do
      state 'saved'
      state_changed_at Time.now
    end

    trait :dismissed do
      state 'dismissed'
      state_changed_at Time.now
    end

    trait :content_card do
      association :resource, factory: :content
    end

    trait :question_card do
      association :resource, factory: :question
    end

    trait :consult_card do
      association :resource, factory: :consult
    end

    trait :consult_card_with_messages do
      association :resource, factory: [:consult, :with_messages]
    end
  end
end
