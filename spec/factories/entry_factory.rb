FactoryGirl.define do
  factory :entry do
    member
    association :actor, factory: :member
    association :resource, factory: :message

    trait :message_entry do
      association :resource, factory: :message
    end

    trait :phone_call_entry do
      association :resource, factory: :phone_call
    end
  end
end
