FactoryGirl.define do
  factory :task_template do
    name "Title"
    title "Title"
    description "Description"
    time_estimate 6 * 60
    queue 'pha'

    trait :with_service_template do
      service_template
    end

    trait :with_service_type do
      service_type
    end
  end
end
