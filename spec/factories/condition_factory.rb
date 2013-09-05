FactoryGirl.define do
  factory :condition, aliases: [:disease] do
    sequence(:name) {|n| "Condition #{n}"}
  end
end
