FactoryGirl.define do
  factory :encounter_user do
    encounter
    user
    role "patient"
  end
end
