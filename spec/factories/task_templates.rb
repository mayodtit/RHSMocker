# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task_template do
    name "Name"
    title "Title"
    description "Description"
    time_estimate 6*60
    service_ordinal 2
    service_template_id 1
  end
end
