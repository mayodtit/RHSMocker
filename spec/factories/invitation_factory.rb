FactoryGirl.define do
  factory :invitation do
    token '1235678910'
    member
    association :invited_member, factory: :member
  end
end
