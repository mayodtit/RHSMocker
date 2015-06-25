FactoryGirl.define do
  factory :task_step_change, :class => 'TaskStepChanges' do
    task_step
    association :actor, factory: :member
    data { {hello: :world} }
  end
end
