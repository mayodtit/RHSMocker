FactoryGirl.define do
  factory :appointment do
    user
    association :provider, factory: :user
    association :creator, factory: :member
    appointment_template
    scheduled_at Time.now + 1.day
    arrived_at Time.now + 2.day
    departed_at Time.now + 2.day + 30.minutes
    special_instructions "special instructions"
    reason_for_visit "reason for visit"
  end
end
