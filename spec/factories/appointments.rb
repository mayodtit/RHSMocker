FactoryGirl.define do
  factory :appointment do
    user
    association :provider, factory: :user
    association :creator, factory: :member
    scheduled_at Time.now + 1.day
  end
end
