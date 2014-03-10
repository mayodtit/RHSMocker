# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message_task, class: MessageTask, parent: :task do
    consult
  end
end
