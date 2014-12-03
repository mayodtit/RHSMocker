# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :view_task_task, class: ViewTaskTask, parent: :task do
    association :assigned_task, factory: :task
    priority 7
  end
end
