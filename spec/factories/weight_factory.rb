FactoryGirl.define do
  factory :weight do
    user
    bmi_level "Normal"
    bmi 5.0
    sequence(:amount) {|n| 80 + n}
    taken_at DateTime.now
  end
end
