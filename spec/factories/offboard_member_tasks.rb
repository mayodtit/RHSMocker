# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :offboard_member_task do
    member
    service_type

    after(:build) { |t| t.member.free_trial_ends_at = 1.day.from_now }
  end
end
