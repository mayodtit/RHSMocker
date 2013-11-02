FactoryGirl.define do
  factory :metadata do
    sequence(:mkey) {|k| "Key #{k}"}
    sequence(:mvalue) {|v| "Value #{v}"}
  end
end
