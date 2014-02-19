FactoryGirl.define do
  factory :permission do
    association :user, factory: :member
    association :subject, factory: :association
    name :basic_info
    level :edit
  end
end
