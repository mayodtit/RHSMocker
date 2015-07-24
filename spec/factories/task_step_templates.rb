FactoryGirl.define do
  factory :task_step_template do
    association :task_template, factory: [:task_template, :with_service_template]
    sequence(:description) {|n| "TaskStepTemplate #{n}" }
    ordinal 0
  end
end
