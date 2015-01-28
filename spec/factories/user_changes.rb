# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_change do
    association :user
    association :actor, factory: :member
    action 'add'
    data({gender: ['male', 'female']})
  end
end
