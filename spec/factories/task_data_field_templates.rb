FactoryGirl.define do
  factory :task_data_field_template do
    task_template
    data_field_template
    ordinal 0
    type :input
  end
end
