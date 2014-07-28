FactoryGirl.define do
  factory :communication_workflow do
    sequence(:name) {|n| "Communication Workflow #{n}"}
  end
end
