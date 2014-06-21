FactoryGirl.define do
  factory :service do
    title "Title"
    description "A description"
    association :service_type
    association :member
    association :subject, factory: :user
    association :creator, factory: :pha
    association :owner, factory: :pha
    association :assignor, factory: :pha
    assigned_at Time.now

    trait :completed do
      state 'completed'
    end

    trait :abandoned do
      state 'abandoned'
      reason_abandoned 'stuff'
    end
  end
end
