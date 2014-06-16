FactoryGirl.define do
  factory :height do
    user
    amount 10
    taken_at Time.now
  end
end
