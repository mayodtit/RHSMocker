namespace :scheduled do

  desc 'Unset premium flag for users with expired subscriptions'
  task :unset_premium => :environment do
    ScheduledJobs.unset_premium_for_expired_subscriptions
  end
end
