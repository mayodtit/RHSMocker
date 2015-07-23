FactoryGirl.define do
  factory :task_data_field_template do
    association :task_template, factory: [:task_template, :with_service_template]
    data_field_template { association(:data_field_template, service_template: task_template.service_template) }
    type :input

    trait :output do
      type :output
    end
  end
end
