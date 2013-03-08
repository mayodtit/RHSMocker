FactoryGirl.define do

  factory :associate do
    sequence(:install_id) { |n| n+100 }
    password              "password"
    password_confirmation "password"

    factory :associate_with_email do
      sequence(:email)    { |n| "user#{n}@test.com" }
    end

  end

end
