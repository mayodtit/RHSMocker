require 'csv'

# Note: This rake task needs to run to export referral codes from the production environment.
desc "Import referral codes from production environment."
task :import_referral_codes_from_production => :environment do
  referral_codes = ReferralCode.where(user_id: nil)
  filename = "referral_codes_from_prod.csv"
  file = Rails.root.join('lib','assets',filename)

  CSV.open(file, 'w') do |writer|
    referral_codes.each do |codes|
      next unless codes.present?
      writer << [codes.name, codes.code, codes.onboarding_group_id]
    end
  end
end

# Note: This rake task needs to run to export referral codes to QA environment.
desc "Export referral codes to QA environment."
task :export_referral_codes_to_QA => :environment do
  filename = 'referral_codes_from_prod.csv'
  encoding = 'ISO-8859-1'

  CSV.foreach(Rails.root.join('lib','assets',filename), encoding: encoding, headers: true) do |row|
    ReferralCode.upsert_attributes!({code: row['code']},
                                    {name: row['name'],
                                    onboarding_group_id: row['onboarding_group_id']})
  end
end
