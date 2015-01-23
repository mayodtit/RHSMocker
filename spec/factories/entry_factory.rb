FactoryGirl.define do
  factory :entry do
    member
    association :actor, factory: :member
    association :resource, factory: :task
  end
end
