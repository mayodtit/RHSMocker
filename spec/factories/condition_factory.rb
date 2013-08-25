FactoryGirl.define do
  factory :condition, aliases: [:disease] do
    sequence(:name){|n| "condition #{n}" }
  end
end
