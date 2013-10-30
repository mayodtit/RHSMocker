FactoryGirl.define do
  factory :invitation do
    sequence(:token) {|n| "#{n}"}
    member
    association :invited_member, factory: :member
  end
end
