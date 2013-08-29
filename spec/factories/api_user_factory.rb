FactoryGirl.define do
  factory :api_user do
    sequence(:name) {|n| "api_user #{n}"}
  end
end
