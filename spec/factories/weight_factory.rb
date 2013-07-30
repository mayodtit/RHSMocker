FactoryGirl.define do
  factory :weight do
    user
    sequence(:amount) {|n| 80 + n}
    taken_at DateTime.now
  end
end
