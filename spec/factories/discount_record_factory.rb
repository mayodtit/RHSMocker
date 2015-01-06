FactoryGirl.define do
  #ArgumentError: Factory not registered: referral_code_id
  factory :discount_record do
    association :user_id, factory: :user
    association :referral_code_id, factory: :referral_code
    coupon
    referrer
    redeemed_at
  end
end