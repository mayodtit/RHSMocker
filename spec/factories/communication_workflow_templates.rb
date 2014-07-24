FactoryGirl.define do
  factory :communication_workflow_template do
    communication_workflow
    days_delayed 1

    factory :message_workflow_template, class: MessageWorkflowTemplate do
      message_template
    end
  end
end
