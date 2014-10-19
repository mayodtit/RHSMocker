namespace :scheduled do

  desc 'Downgrade users with expired subscriptions or free trials'
  task :downgrade_members => :environment do
    ScheduledJobs.downgrade_members
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

  desc 'Alert stakeholders when there is low welcome call availability'
  task :alert_stakeholders_when_low_welcome_call_availability => :environment do
    ScheduledJobs.alert_stakeholders_when_low_welcome_call_availability
  end

  desc 'Send referral card'
  task :send_referral_card => :environment do
    ScheduledJobs.send_referral_card
  end

  desc 'Push content to all members'
  task :push_content => :environment do
    ScheduledJobs.push_content
  end

  desc 'Offboard free trial members'
  task :offboard_free_trial_members => :environment do
    ScheduledJobs.offboard_free_trial_members
  end
end
