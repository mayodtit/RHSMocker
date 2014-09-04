class ScheduledJobs
  def self.downgrade_members
    if Metadata.offboard_free_trial_members?
      Member.where('status = ? AND free_trial_ends_at < ? AND signed_up_at >= ?', :trial, Time.now, Metadata.offboard_free_trial_start_date).each do |member|
        member.downgrade!
      end
    end

    if Metadata.offboard_expired_members?
      Member.where('status = ? AND subscription_ends_at < ?', :premium, Time.now).each do |member|
        member.downgrade!
      end
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
        TwilioModule.message s.text_phone_number, body
      end
    end
  end

  def self.alert_stakeholders_when_no_pha_on_call
    if Role.pha.on_call? && Role.pha.users.where(on_call: true).count == 0
      body = "ALERT: No PHAs triaging!"

      Role.pha_stakeholders.each do |s|
        TwilioModule.message s.text_phone_number, body
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
      begin
        m = m.reload
        m.cancel! unless m.canceled?
      rescue
        next
      end
    end
    ScheduledCommunication.scheduled.publish_at_past_time.each do |m|
      begin
        m = m.reload
        m.deliver! unless m.delivered?
      rescue
        next
      end
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
      Member.where('status = ? AND DATEDIFF(?,free_trial_ends_at) <= 6 AND signed_up_at >= ?', :trial, Time.now, Metadata.offboard_free_trial_start_date).each do |member|
        if OffboardMemberTask::OFFBOARDING_WINDOW.after(Time.now.pacific).pacific.to_date >= member.free_trial_ends_at.pacific.to_date && member.engaged?
          t = OffboardMemberTask.create_if_only_for_current_free_trial member
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
