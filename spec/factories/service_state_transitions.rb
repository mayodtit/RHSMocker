# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :service_state_transition do
    association :service
    event 'complete'
    from 'open'
    to 'completed'
    created_at '2014-06-19 14:27:58'
    association :actor, factory: :pha
  end
end
