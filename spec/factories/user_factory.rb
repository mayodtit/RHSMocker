FactoryGirl.define do
  factory :user, aliases: [:associate] do
    first_name            { ["Harold", "Kumar", "Alice", "Bob"].sample }
    last_name             { ["Lee", "Patel", "Carol", "Dan"].sample }
    association :owner, factory: :member
    on_call false

    factory :member, class: Member, aliases: [:user_with_email] do
      sequence(:email)    { |n| "user#{n}@test.com" }
      password              "password"
      member_flag true
      owner nil
      status 'free'
      email_confirmed true

      trait :invited do
        status 'invited'
        sequence(:invitation_token) {|n| "INVITATION-TOKEN-#{n}"}
        password nil
      end

      trait :free do
        status 'free'
        signed_up_at Time.now
      end

      trait :trial do
        status 'trial'
        signed_up_at Time.now
        free_trial_ends_at Time.now + 2.weeks
      end

      trait :premium do
        status 'premium'
        signed_up_at Time.now
      end

      trait :chamath do
        status 'chamath'
        signed_up_at Time.now
      end

      trait :with_stripe_customer_id do
        sequence(:stripe_customer_id) {|n| "cus_#{n}"}
      end

      trait :admin_role do
        after(:create) {|user| user.add_role(:admin)}
      end
      factory :admin, traits: %i(admin_role)

      trait :super_admin_role do
        after(:create) {|user| user.add_role(:super_admin)}
      end
      factory :super_admin, traits: %i(super_admin_role)

      trait :nurse_role do
        after(:create) do |user|
          user.add_role(:nurse)
          user.work_phone_number = '4083913578'
        end
      end
      factory :nurse, traits: %i(nurse_role)

      trait :pha_role do
        after(:create) do |user|
          user.add_role(:pha)
          user.work_phone_number = '5552223333'
        end
      end
      factory :pha, traits: %i(pha_role)

      trait :pha_lead_role do
        after(:create) do |user|
          user.add_role(:pha_lead)
          user.work_phone_number = '4153333333'
        end
      end
      factory :pha_lead, traits: %i(pha_lead_role)

      factory :kyle, traits: %i(chamath) do
        first_name 'Kyle'
        last_name 'Chilcutt'
        email 'kyle@getbetter.com'
        password 'password'
      end
    end
  end
end
