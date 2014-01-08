FactoryGirl.define do
  factory :waitlist_entry do
    sequence(:email) {|n| "email+#{n}@test.getbetter.com"}
  end
end
