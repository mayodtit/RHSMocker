FactoryGirl.define do
  factory :task_step_data_field_template do
    task_step_template
    association :task_data_field_template, :output
    ordinal 0
  end
end
