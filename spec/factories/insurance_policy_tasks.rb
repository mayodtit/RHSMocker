FactoryGirl.define do
  factory :insurance_policy_task, class: InsurancePolicyTask, parent: :task do
    member
    association :subject, factory: :user
  end
end
