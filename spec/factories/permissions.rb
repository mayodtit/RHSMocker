FactoryGirl.define do
  factory :permission do
    association :subject, factory: :association
    basic_info :edit
    medical_info :edit
    care_team :edit
  end
end
