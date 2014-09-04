FactoryGirl.define do
  factory :scheduled_phone_call do
    scheduled_at { 2.days.from_now }
    callback_phone_number { '9113114111' }

    trait :assigned do
      state 'assigned'
      association :assignor, factory: :pha_lead
      association :owner, factory: :pha
      assigned_at Time.now
    end

    trait :booked do
      state 'booked'
      association :user, factory: :member
      association :owner, factory: :pha
      booker { user }
      booked_at Time.now
    end

    trait :ended do
      state 'ended'
      association :user, factory: :member
      association :owner, factory: :pha
      booker { user }
      booked_at Time.now
      ender { user }
      ended_at Time.now
    end

    trait :canceled do
      state 'canceled'
      association :user, factory: :member
      association :owner, factory: :pha
      booker { user }
      booked_at Time.now
      canceler { user }
      canceled_at Time.now
    end

    trait :w_message do
      association :message, factory: :message
    end
  end
end
