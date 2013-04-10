FactoryGirl.define do

  factory :user do
    sequence(:install_id) { |n| n }
    password              "password"
    password_confirmation "password"
    first_name            { ["Harold", "Kumar", "Alice", "Bob"].sample }
    last_name             { ["Lee", "Patel", "Carol", "Dan"].sample }

    factory :user_with_email do
      sequence(:email)    { |n| "user#{n}@test.com" }

      factory :hcp_user do
        after(:create) {|user| user.add_role(:hcp)}
      end
    end
  end
end
