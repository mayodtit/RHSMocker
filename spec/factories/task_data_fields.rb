FactoryGirl.define do
  factory :task_data_field do
    task
    data_field
    task_data_field_template
    type :input

    trait :output do
      type :output
    end
  end
end
