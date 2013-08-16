FactoryGirl.define do
  factory :offering do
    sequence(:name) {|n| "Offering #{n}"}
  end
end
