class ScheduledJobs
  def self.unset_premium_for_expired_subscriptions
    Member.where('free_trial_ends_at < ?', DateTime.now).each do |user|
      Rails.logger.info "Unsetting premium flag for user #{user.id} - free trial expired #{user.free_trial_ends_at}"
      user.is_premium = false
      user.free_trial_ends_at = nil
      user.subscription_ends_at = nil
      user.save!
    end

    Member.where('subscription_ends_at < ?', DateTime.now).each do |user|
      Rails.logger.info "Unsetting premium flag for user #{user.id} - subscription expired #{user.subscription_ends_at}"
      user.is_premium = false
      user.free_trial_ends_at = nil
      user.subscription_ends_at = nil
      user.save!
    end
  end

  # NOTE: Should run every hour to account for Daylight Savings.
  def self.unforce_phas_off_call
    m = Metadata.find_by_mkey('force_phas_off_call')

    if m && m.mvalue == 'true'
      now = Time.now.in_time_zone 'America/Los_Angeles'
      set_at = m.updated_at.in_time_zone 'America/Los_Angeles'

      if now.day() != set_at.day()
        m.mvalue = 'false'
        m.save!
      end
    end
  end

  def self.alert_leads_when_phas_forced_off_call
    if Metadata.force_phas_off_call?
      body = "PHAs are currently forced after hours. This can be changed via the Care Portal."
      body = "#{Rails.env} - #{body}" unless Rails.env.production?

      Role.pha_stakeholders.each do |s|
        if s.work_phone_number
          PhoneCall.twilio.account.messages.create(
            from: PhoneNumberUtil::format_for_dialing(SERVICE_ALERT_PHONE_NUMBER),
            to: PhoneNumberUtil::format_for_dialing(s.work_phone_number),
            body: body
          )
        end
      end
    end
  end
end
