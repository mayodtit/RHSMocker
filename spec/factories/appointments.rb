FactoryGirl.define do
  factory :appointment do
    user
    association :provider, factory: :user
    scheduled_at Time.now + 1.day
  end
end
