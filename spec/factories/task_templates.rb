FactoryGirl.define do
  factory :task_template do
    name "Title"
    title "Title"
    description "Description"
    time_estimate 6 * 60
  end
end
