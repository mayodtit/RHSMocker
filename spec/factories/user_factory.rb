FactoryGirl.define do
  factory :user, aliases: [:associate] do
    first_name            { ["Harold", "Kumar", "Alice", "Bob"].sample }
    last_name             { ["Lee", "Patel", "Carol", "Dan"].sample }
    association :owner, factory: :member
    on_call false

    factory :member, class: Member, aliases: [:user_with_email] do
      sequence(:install_id) { |n| "Install-ID-#{n}" }
      sequence(:email)    { |n| "user#{n}@test.com" }
      password              "password"
      member_flag true
      owner nil
      status 'free'

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
