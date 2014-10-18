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
      if user = Session.find_by_advertiser_id(row['IDFA']).try(:member)
        user.update_attribute(:advertiser_id, row['IDFA'])
        user.update_attribute(:advertiser_media_source, row['Media Source (pid)'])
        user.update_attribute(:advertiser_campaign, row['Campaign (c)'])
        print '.'
      else
        print '*'
      end
      count + 1
    end
  end
end
