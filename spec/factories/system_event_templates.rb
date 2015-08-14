FactoryGirl.define do
  factory :system_event_template do
    name "Template"
    title "Title"
    description "Description"
    appointment_template

    factory :system_relative_event_template, class: SystemRelativeEventTemplate do
      association :root_event_template, factory: :system_event_template
      time_offset
    end
  end
end
