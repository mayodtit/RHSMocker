# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task_change do
    association :task, factory: :member_task
    association :actor, factory: :member
    event 'update'
    data({description: ['first description', 'second description']})
    created_at "2014-10-09 16:39:14"
  end
end
