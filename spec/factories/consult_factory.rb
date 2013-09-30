FactoryGirl.define do
  factory :consult, aliases: [:encounter] do
    sequence(:title) {|n| "Consult #{n}"}
    association :initiator, factory: :member
    association :subject, factory: :user
    users {|e| [e.initiator]}
    status { :open }
    priority { ['high', 'medium', 'low'].sample }
    checked false
    description 'description'

    trait :with_messages do
      messages {|m| [m.association(:message)]}
    end
  end
end
