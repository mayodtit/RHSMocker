FactoryGirl.define do
  factory :user, aliases: [:associate] do
    first_name            { ["Harold", "Kumar", "Alice", "Bob"].sample }
    last_name             { ["Lee", "Patel", "Carol", "Dan"].sample }

    factory :member, class: Member, aliases: [:user_with_email] do
      sequence(:install_id) { |n| "Install-ID-#{n}" }
      sequence(:email)    { |n| "user#{n}@test.com" }
      password              "password"
      password_confirmation "password"

      factory :admin do
        after(:create) {|user| user.add_role(:admin)}
      end

      factory :nurse do
        work_phone_number '4083913578'
        after(:create) {|user| user.add_role(:nurse)}
      end

      factory :pha do
        work_phone_number '5552223333'
        after(:create) {|user| user.add_role(:pha)}
      end

      factory :pha_lead do
        work_phone_number '4153333333'
        after(:create) {|user| user.add_role(:pha_lead)}
      end
    end
  end
end
