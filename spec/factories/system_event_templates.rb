# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :system_event_template do
    name "Template"
    title "Title"
    description "Description"

    factory :system_relative_event_template, class: SystemRelativeEventTemplate do
      association :root_event_template, factory: :system_event_template
      association :time_offset
    end
  end
end
