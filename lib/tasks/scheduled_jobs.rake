namespace :scheduled do

  desc 'Unset premium flag for users with expired subscriptions'
  task :unset_premium => :environment do
    ScheduledJobs.unset_premium_for_expired_subscriptions
  end

  desc 'Unforce phas of call if it\'s the next day'
  task :unforce_phas_off_call => :environment do
    ScheduledJobs.unforce_phas_off_call
  end

  desc 'Alert stakeholders when phas are forced off call'
  task :alert_stakeholders_when_phas_forced_off_call => :environment do
    ScheduledJobs.alert_stakeholders_when_phas_forced_off_call
  end

  desc 'Alert stakeholders when phas are forced off call'
  task :alert_stakeholders_when_no_pha_on_call => :environment do
    ScheduledJobs.alert_stakeholders_when_no_pha_on_call
  end
end
