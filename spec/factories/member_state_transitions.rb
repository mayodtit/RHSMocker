FactoryGirl.define do
  factory :member_state_transition do
    member
    event "Event"
    from "State1"
    to "State2"
    created_at Time.now
  end
end
