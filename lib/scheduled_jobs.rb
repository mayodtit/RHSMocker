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

  def self.alert_stakeholders_when_phas_forced_off_call
    if Metadata.force_phas_off_call?
      body = "ALERT: PHAs are currently forced after hours. This can be changed via the Care Portal."

      Role.pha_stakeholders.each do |s|
        TwilioModule.message s.work_phone_number, body
      end
    end
  end

  def self.alert_stakeholders_when_no_pha_on_call
    if Role.pha.on_call? && Role.pha.users.where(on_call: true).count == 0
      body = "ALERT: No PHAs triaging!"

      Role.pha_stakeholders.each do |s|
        TwilioModule.message s.work_phone_number, body
      end
    end
  end

  def self.alert_stakeholders_when_low_welcome_call_availability
    start_time = Time.now
    end_time = start_time + 1.week

    available_call_counts = Member.phas_with_profile.inject({}) do |hash, pha|
      available_count = pha.owned_scheduled_phone_calls.assigned.in_period(start_time, end_time).count
      if available_count < 5
        hash[pha] = available_count
      end
      hash
    end

    if available_call_counts.any?
      UserMailer.notify_of_low_welcome_call_availability(available_call_counts).deliver
    end
  end

  def self.transition_scheduled_communications
    ScheduledCommunication.held.publish_at_past_time.each do |m|
      m.cancel!
    end
    ScheduledCommunication.scheduled.publish_at_past_time.each do |m|
      m.deliver!
    end
  end

  def self.send_referral_card
    return unless CustomCard.referral
    Member.where('signed_up_at < ?', Time.now - 5.days).find_each do |m|
      next if m.cards.where(resource_id: CustomCard.referral.id, resource_type: 'CustomCard').any?
      m.cards.create(resource: CustomCard.referral)
    end
  end

  def self.push_content
    Member.find_each do |m|
      count = m.cards.inbox.count
      next if count >= 5
      (5 - count).times do
        content = Content.next_for(m)
        break unless content
        m.cards.create(resource: content, user_program: content.user_program)
      end
    end
  end

  def self.offboard_free_trial_members
    if Metadata.offboard_free_trial_members?
      Member.where('free_trial_ends_at < ?', Time.now - OffboardMemberTask::OFFBOARDING_WINDOW).each do |member|
        if member.engaged?
          t = OffboardMemberTask.create_if_only_within_offboarding_window member
          if !t || t.valid?
            Rails.logger.info "Offboarded Member #{member.id}"
          else
            Rails.logger.error "Could not create OffboardMemberTask for Member #{member.id}"
          end
        end
      end
    end
  end
end
