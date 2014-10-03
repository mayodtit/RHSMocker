FactoryGirl.define do
  factory :missed_call_task, class: MissedCallTask, parent: :task do
    phone_call
  end
end
