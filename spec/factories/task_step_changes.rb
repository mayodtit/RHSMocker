FactoryGirl.define do
  factory :task_step_change do
    task_step
    association :actor, factory: :member
    data { {hello: :world} }
  end
end
