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

  desc 'Alert stakeholders when there is low welcome call availability'
  task :alert_stakeholders_when_low_welcome_call_availability => :environment do
    ScheduledJobs.alert_stakeholders_when_low_welcome_call_availability
  end

  desc 'Transitions scheduled communications'
  task transition_scheduled_communications: :environment do
    ScheduledJobs.transition_scheduled_communications
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
