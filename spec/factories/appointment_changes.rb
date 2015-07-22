FactoryGirl.define do
  factory :appointment_change do
    association :appointment
    association :actor, factory: :member
    event 'update'
    from 'open'
    to 'updatad'
    data({description: ['first description', 'second description']})
    created_at "2014-10-09 16:39:14"
  end
end
