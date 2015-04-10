# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :service_change do
    association :service
    association :actor, factory: :member
    event 'complete'
    from 'open'
    to 'completed'
    data({description: ['first description', 'second description']})
    created_at "2014-10-09 16:39:14"
  end
end
