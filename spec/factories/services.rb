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

    trait :draft do
      state 'draft'
    end

    trait 'waiting' do
      state 'waiting'
    end

    trait :open do
      state 'open'
    end

    trait :completed do
      state 'completed'
    end

    trait :abandoned do
      state 'abandoned'
      reason_abandoned 'stuff'
    end
  end
end
