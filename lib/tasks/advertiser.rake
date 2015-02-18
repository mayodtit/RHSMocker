require 'csv'

namespace :advertiser do
  task import: :environment do
    file = File.read(Rails.root.join('lib', 'assets', 'advertiser_data.csv'), encoding: 'ISO-8859-1')
    csv = CSV.parse(file, headers: true)
    puts "***** PROCESSING CSV OF LENGTH #{csv.length} *****"
    csv.inject(0) do |count, row|
      if (count % 1000) == 0
        puts count
      end

      found = false

      if user = Session.find_by_advertiser_id(row['IDFA']).try(:member)
        user.advertiser_id = row['IDFA']
        user.advertiser_media_source = row['Media Source (pid)']
        user.advertiser_campaign = row['Campaign (c)']
        user.save(false)
        found = true
      end

      if enrollment = Enrollment.find_by_advertiser_id(row['IDFA'])
        enrollment.advertiser_media_source = row['Media Source (pid)']
        enrollment.advertiser_campaign = row['Campaign (c)']
        enrollment.save(false)
        found = true
      end

      found ? print('.') : print('*')
      count + 1
    end
  end
end
