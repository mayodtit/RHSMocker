# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :add_tasks_task, class: AddTasksTask, parent: :task do
    member
    association :subject, factory: :member
    association :service_type
    title 'Find new services for member'
    priority 0
  end
end
