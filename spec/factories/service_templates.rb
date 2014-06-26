# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :service_template do
    name "Template"
    title "Title"
    description "Description"
    association :service_type
    time_estimate 48*60
  end
end
