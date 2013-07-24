FactoryGirl.define do
  factory :invitation do
    member
    association :invited_member, factory: :member
  end
end
