FactoryGirl.define do
  factory :consult_user do
    consult
    user
    role "patient"
  end
end
