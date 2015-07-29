FactoryGirl.define do
  factory :task_step_data_field do
    task_step
    association(:task_data_field, :output)
    task_step_data_field_template
  end
end
