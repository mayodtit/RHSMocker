FactoryGirl.define do
  factory :consult, aliases: [:encounter] do
    association :initiator, factory: :member
    association :subject, factory: :user
    users {|e| [e.initiator]}
    status { 'open' }
    priority { ['high', 'medium', 'low'].sample }
    checked false

    trait :with_messages do
      messages {|m| [m.association(:message)]}
    end
  end
end
