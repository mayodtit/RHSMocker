FactoryGirl.define do
  #ArgumentError: Factory not registered: referral_code_id
  factory :discount do
    association :user_id, factory: :member
    association :referral_code_id, factory: :referral_code
    coupon 'One_Time_Fifty_Percent_Off'
    referrer 'True'
    redeemed_at Time.now
  end
end
