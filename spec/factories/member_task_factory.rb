# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :member_task, class: MemberTask, parent: :task do
    member
    association :subject, factory: :user
    association :service_type
  end
end
