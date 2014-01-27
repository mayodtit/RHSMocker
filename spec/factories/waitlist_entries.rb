FactoryGirl.define do
  factory :waitlist_entry do
    sequence(:email) {|n| "email+#{n}@test.getbetter.com"}

    trait :invited do
      state 'invited'
      invited_at Time.now
      sequence(:token) {|n| "%05d" % n}
    end

    trait :claimed do
      state 'claimed'
      association :claimer, factory: :member
      claimed_at Time.now
    end

    trait :revoked do
      state 'revoked'
      association :revoker, factory: :member
      revoked_at Time.now
    end
  end
end
