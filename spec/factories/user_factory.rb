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
        after(:create) {|user| user.add_role(:nurse)}
      end

      factory :pha do
        after(:create) {|user| user.add_role(:pha)}
      end

      factory :pha_lead do
        after(:create) {|user| user.add_role(:pha_lead)}
      end
    end
  end
end
