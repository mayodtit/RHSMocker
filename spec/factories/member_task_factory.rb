FactoryGirl.define do
  factory :member_task, class: MemberTask, parent: :task do
    member
    association :subject, factory: :user
    association :service_type
    unread false
  end
end
