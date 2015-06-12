FactoryGirl.define do
  factory :new_kinsights_member_task, class: NewKinsightsMemberTask, parent: :task do
    member
    association :subject, factory: :user
  end
end
