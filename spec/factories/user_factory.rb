FactoryGirl.define do
  factory :user, aliases: [:associate] do
    first_name            { ["Harold", "Kumar", "Alice", "Bob"].sample }
    last_name             { ["Lee", "Patel", "Carol", "Dan"].sample }

    factory :member, class: Member do
      sequence(:install_id) { |n| n }
      password              "password"
      password_confirmation "password"

      factory :user_with_email do
        sequence(:email)    { |n| "user#{n}@test.com" }

        factory :admin do
          after(:create) {|user| user.add_role(:admin)}
        end

        factory :hcp_user do
          after(:create) {|user| user.add_role(:hcp)}
        end
      end
    end
  end
end
