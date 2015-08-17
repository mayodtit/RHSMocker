FactoryGirl.define do
  factory :appointment_change do
    appointment
    association :actor, factory: :member
    data({description: ['first description', 'second description']})
  end
end
