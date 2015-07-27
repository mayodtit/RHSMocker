FactoryGirl.define do
  factory :message_task, class: MessageTask, parent: :task do
    consult
    message { association :message, consult: consult, user: consult.initiator, skip_message_task_creation: true }
  end

  trait :spam do
    state 'spam'
    association :owner, factory: :member
    association :assignor, factory: :member
  end
end
