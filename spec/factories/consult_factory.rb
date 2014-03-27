FactoryGirl.define do
  factory :consult do
    association :initiator, factory: :member
    association :subject, factory: :user
    sequence(:title) {|n| "Consult #{n}"}

    trait :master do
      master true
    end

    trait :with_messages do
      messages {|m| [m.association(:message)]}
    end
  end
end
