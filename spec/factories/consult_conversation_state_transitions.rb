# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :consult_conversation_state_transition do
    association :consult
    event "flag"
    from "active"
    to "needs_response"
    created_at "2014-10-09 16:19:35"
  end
end
