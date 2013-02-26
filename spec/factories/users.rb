FactoryGirl.define do
  factory :user do
    sequence(:install_id) { |n| n }

    factory :user_with_email do
      sequence(:email)      { |n| "user#{n}@test.com" }
      password              "password"
      sequence(:install_id) { |n| "1234#{n}" }
    end
  end

end
