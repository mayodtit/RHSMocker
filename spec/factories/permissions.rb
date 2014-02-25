FactoryGirl.define do
  factory :permission do
    basic_info :edit
    medical_info :edit
    care_team :edit

    after(:build) do |p|
      p.subject ||= build(:association, permission: p)
    end
  end
end
