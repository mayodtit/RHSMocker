FactoryGirl.define do
  factory :subscription do
    association :user, factory: [:member, :premium]
    start Time.now.to_i
    status 'active'
    customer 'stripe_customer'
    cancel_at_period_end false
    current_period_start Time.now.to_i
    current_period_end  Time.now.to_i+100
    quantity 1
    plan_id 'bp'

    trait :trialing do
      status 'trialing'
    end

    trait :active do
      status 'active'
    end

    trait :past_due do
      status 'past_due'
    end

    trait :canceled do
      status 'canceled'
    end

    trait :unpaid do
      status 'unpaid'
    end
  end
end