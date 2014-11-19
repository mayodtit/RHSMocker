# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :no_tasks_task, class: NoTasksTask, parent: :task do
    member
    association :subject, factory: :member
    association :service_type
    title 'Find new services for member'
  end
end
