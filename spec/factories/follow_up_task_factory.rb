FactoryGirl.define do
  factory :follow_up_task, class: FollowUpTask, parent: :task do
    phone_call
  end
end
