FactoryGirl.define do
  factory :member_state_transition do
    member
    actor { member }
    event 'Event'
    from 'State1'
    to 'State2'
    created_at Time.now

    trait :to_trial do
      to 'trial'
      free_trial_ends_at { member.free_trial_ends_at || Time.now + 1.day }
    end
  end
end
