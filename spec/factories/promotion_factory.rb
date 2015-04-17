FactoryGirl.define do
  factory :promotion do
    sequence(:name) { |n| "Promotion #{n}" }
  end
end
