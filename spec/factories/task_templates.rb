FactoryGirl.define do
  factory :task_template do
    name "Title"
    title "Title"
    description "Description"
    time_estimate 6 * 60

    trait :with_service_template do
      service_template
    end
  end
end
