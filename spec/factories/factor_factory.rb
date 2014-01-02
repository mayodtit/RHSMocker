FactoryGirl.define do
  factory :factor do
    factor_group
    sequence(:name) {|n| "Factor #{n}"}
  end
end
