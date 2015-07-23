namespace :seeds do
  task onboarding: :environment do |t, args|
    o = OnboardingGroup.find_or_create_by_name(name: 'Premium, No Credit Card',
                                               premium: true,
                                               skip_credit_card: true)
    ReferralCode.find_or_create_by_name(name: 'Premium, No Credit Card',
                                        code: 'premium',
                                        onboarding_group: o)

    o = OnboardingGroup.find_or_create_by_name(name: 'Trial, No Credit Card',
                                               premium: true,
                                               free_trial_days: 30,
                                               skip_credit_card: true)
    ReferralCode.find_or_create_by_name(name: 'Trial, No Credit Card',
                                        code: 'trial',
                                        onboarding_group: o)

    o = OnboardingGroup.find_or_create_by_name(name: 'Premium, Group',
                                               premium: true,
                                               free_trial_days: 0,
                                               subscription_days: 120,
                                               skip_credit_card: true,
                                               remote_header_asset_url: 'https://s3-us-west-2.amazonaws.com/btr-static/images/custom_onboarding_header.png',
                                               remote_background_asset_url: 'https://s3-us-west-2.amazonaws.com/btr-static/images/custom_onboarding_background.png',
                                               custom_welcome: "This is a onboarding group to use as a test for custom onboarding. It has some placeholder text.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vehicula nulla sed purus pharetra ullamcorper. Donec consectetur est libero, sit amet cursus nisi cursus sed. Nam blandit blandit orci, id lacinia odio luctus sed. Donec sed fermentum massa, id viverra eros.")
    ReferralCode.find_or_create_by_name(name: 'Premium, Group',
                                        code: 'group',
                                        onboarding_group: o)
  end
end
