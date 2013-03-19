FactoryGirl.define do

  factory :user do
    sequence(:install_id) { |n| n }
    password              "password"
    password_confirmation "password"
    first_name "Harold"
    last_name "Kumar"

    factory :user_with_email do
      sequence(:email)    { |n| "user#{n}@test.com" }
    end
  end

end
