FactoryGirl.define do
  factory :plan do
    sequence(:name) {|n| "Plan #{n}"}
    description 'description'
    price '49.99'
  end
end
