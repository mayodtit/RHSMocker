FactoryGirl.define do
  factory :metadata do
    sequence(:key) {|k| "Key #{k}"}
    sequence(:value) {|v| "Value #{v}"}
  end
end
