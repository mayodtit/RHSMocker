FactoryGirl.define do
  factory :encounter do
    association :subject, factory: :user
    users {|e| [e.association(:member)]}
    status { 'open' }
    priority { ['high', 'medium', 'low'].sample }
    checked false

    trait :with_messages do
      messages {|m| [m.association(:message)]}
    end
  end
end
