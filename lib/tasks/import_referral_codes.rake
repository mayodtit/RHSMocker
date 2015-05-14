require 'csv'

# Note: This rake task needs to run on "production" to export referral codes from the production environment.
desc "Import referral codes from production environment."
task :import_referral_codes_from_production => :environment do
  referral_codes = ReferralCode.where(user_id: nil).includes(:onboarding_group)
  filename = "referral_codes_from_prod.csv"
  file = Rails.root.join('lib','assets',filename)

  CSV.open(file, 'w', :write_headers=> true, :headers => ["name", "code", "onboarding_group_name", "onboarding_group_premium", "onboarding_group_free_trial_days", "onboarding_group_subscription_days", "onboarding_group_skip_credit_card", "onboarding_group_skip_automated_communications", "onboarding_group_skip_emails"]) do |writer|
    referral_codes.each do |codes|
      next unless codes.present?
      writer << [codes.name,
                 codes.code,
                 codes.onboarding_group.try(:name),
                 codes.onboarding_group.try(:premium),
                 codes.onboarding_group.try(:free_trial_days),
                 codes.onboarding_group.try(:subscription_days),
                 codes.onboarding_group.try(:skip_credit_card),
                 codes.onboarding_group.try(:skip_automated_communications),
                 codes.onboarding_group.try(:skip_emails)
      ]
    end
  end
end

# Note: This rake task needs to run on "QA" to export referral codes to QA environment.
desc "Export referral codes to QA environment."
task :export_referral_codes_to_QA => :environment do
  filename = 'referral_codes_from_prod.csv'
  encoding = 'ISO-8859-1'

  CSV.foreach(Rails.root.join('lib','assets',filename), encoding: encoding, headers: true) do |row|
    ReferralCode.upsert_attributes!({code: row['code']},
                                    {name: row['name']})
  end
end
