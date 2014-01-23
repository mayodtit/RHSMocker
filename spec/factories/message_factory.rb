FactoryGirl.define do
  factory :message do
    association :user, factory: :member
    consult

    trait :with_content do
      content
    end

    trait :with_phone_call do
      phone_call
    end

    trait :with_scheduled_phone_call do
      scheduled_phone_call
    end

    trait :with_phone_call_summary do
      phone_call_summary
    end
  end
end
