FactoryGirl.define do
  factory :service do
    title "Title"
    description "A description"
    service_type
    member
    subject { member }
    association :creator, factory: :pha
    owner { creator }
    assignor { creator }
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
