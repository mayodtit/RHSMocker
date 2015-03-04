FactoryGirl.define do
  factory :subscription do
    association :user, factory: [:member, :premium]
    start Time.now.to_i
    status 'active'
    cancel_at_period_end false
    current_period_start Time.now.to_i
    current_period_end  Time.now.to_i+1000
    quantity 1
    plan Stripe::Plan.all.data[0].to_hash
    sequence(:stripe_subscription_id) { |n|"stripe_subscription #{n}" }
    sequence(:customer) { |n|"stripe_customer#{n}" }

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

    trait :bp20 do
      plan Stripe::Plan.retrieve('bp20').to_hash
    end

    trait :bp50 do
      plan Stripe::Plan.retrieve('bp50').to_hash
    end
  end
end
