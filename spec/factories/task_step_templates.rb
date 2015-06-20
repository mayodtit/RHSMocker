FactoryGirl.define do
  factory :task_step_template do
    task_template
    sequence(:description) {|n| "TaskStepTemplate #{n}" }
    ordinal 0
  end
end
