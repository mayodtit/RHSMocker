FactoryGirl.define do
  factory :welcome_call_task, class: WelcomeCallTask, parent: :task do
    association :scheduled_phone_call
    title 'Welcome Call'
    association :member
    association :owner, factory: :member
    association :assignor, factory: :member
    priority 0
  end
end
