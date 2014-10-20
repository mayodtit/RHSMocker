namespace :scheduled_communications do
  desc 'Create Delayed::Jobs for all ScheduledCommunications'
  task create_delivery_jobs: :environment do
    scheduled = ScheduledCommunication.where(state: %i(scheduled held))
    puts "***** PROCESSING #{scheduled.count} SCHEDULED COMMUNICATIONS *****"
    count = 0
    scheduled.find_each do |s|
      if (count % 1000) == 0
        puts count
      end
      if s.scheduled? || s.held?
        s.create_delivery_job
        print '.'
      else
        print '*'
      end
      count += 1
    end
  end
end
