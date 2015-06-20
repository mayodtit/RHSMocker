FactoryGirl.define do
  factory :task_step do
    task
    task_step_template
    completed false
  end
end
