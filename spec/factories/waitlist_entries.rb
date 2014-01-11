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
      claimed_at Time.now
    end
  end
end
