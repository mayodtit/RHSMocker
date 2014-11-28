# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message_member_task, class: MessageMemberTask, parent: :task do
    member
    service_type
    title 'Message member'
    priority 0
  end
end
