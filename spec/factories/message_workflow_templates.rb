FactoryGirl.define do
  factory :message_workflow_template do
    message_workflow
    message_template
    days_delayed 1
  end
end
