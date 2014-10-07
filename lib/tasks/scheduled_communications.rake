namespace :scheduled_communications do
  desc 'Create Delayed::Jobs for all ScheduledCommunications'
  task create_delivery_jobs: :environment do
    ScheduledCommunication.find_each do |s|
      if s.scheduled? || s.held?
        s.create_delivery_job
        s.save!
      end
    end
  end
end
