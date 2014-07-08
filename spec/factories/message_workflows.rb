FactoryGirl.define do
  factory :message_workflow do
    sequence(:name) {|n| "Message Workflow #{n}"}
  end
end
