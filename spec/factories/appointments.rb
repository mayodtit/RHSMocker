FactoryGirl.define do
  factory :appointment do
    user
    association :provider, factory: :user
    association :creator, factory: :member
    appointment_template
    scheduled_at Time.now + 1.day
    arrival_time Time.now + 2.day
    departure_time Time.now + 2.day + 30.minutes
  end
end
