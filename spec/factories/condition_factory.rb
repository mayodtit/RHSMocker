FactoryGirl.define do
  factory :condition do
    sequence(:name){|n| "condition #{n}" }
  end
end
