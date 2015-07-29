FactoryGirl.define do
  factory :appointment_change do
    appointment
    association :actor, factory: :member
    event 'update'
    from 'open'
    to 'updatad'
    data({description: ['first description', 'second description']})
  end
end
