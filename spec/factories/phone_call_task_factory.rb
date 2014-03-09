# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :phone_call_task, class: PhoneCallTask, parent: :task do
    phone_call
  end
end
