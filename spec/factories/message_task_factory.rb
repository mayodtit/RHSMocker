# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message_task, class: MessageTask, parent: :task do
    consult
  end

  trait :spam do
    state 'spam'
    association :owner, factory: :member
    association :assignor, factory: :member
  end
end
