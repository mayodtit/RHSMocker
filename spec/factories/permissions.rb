FactoryGirl.define do
  factory :permission do
    association :subject, factory: :association
    name :basic_info
    level :edit
  end
end
