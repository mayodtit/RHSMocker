FactoryGirl.define do
  factory :expertise do
    sequence(:name) {|n| "expertise-#{n}"}
  end
end
