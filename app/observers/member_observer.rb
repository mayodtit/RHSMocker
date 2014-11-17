class MemberObserver < ActiveRecord::Observer
  def after_commit(member)
    add_automated_communication_workflows(member)
    send_state_emails(member)
    send_confirm_email_email(member)
    set_self_owner(member)
  end

  private

  def add_automated_communication_workflows(member)
    return unless member.previous_changes[:status]
    return unless member.inbound_scheduled_communications.empty?
    member.transaction do
      if member.trial?
        if Metadata.automated_onboarding?
          CommunicationWorkflow.automated_onboarding.try(:add_to_member, member)
        end
        if Metadata.automated_offboarding?
          CommunicationWorkflow.automated_offboarding.try(:add_to_member, member)
        end
      elsif member.premium?
        CommunicationWorkflow.automated_onboarding_something_else.try(:add_to_member, member)
      end
    end
  end

  def send_state_emails(member)
    return unless member.previous_changes[:status]
    if member.trial?
      return if MemberStateTransition.multiple_exist_for?(member, :trial)
      if member.onboarding_group.try(:mayo_pilot?) && member.onboarding_group.try(:provider)
        Mails::MayoPilotMeetYourPhaJob.create(member.id, member.onboarding_group.provider.id)
      else
        Mails::MeetYourPhaJob.create(member.id)
      end
    elsif member.premium?
      return if MemberStateTransition.multiple_exist_for?(member, :premium)
      return if MemberStateTransition.multiple_exist_for?(member, :trial)
      Mails::MeetYourPhaMonthTrialJob.create(member.id)
    elsif member.invited?
      return if MemberStateTransition.multiple_exist_for?(member, :invited)
      if member.onboarding_group.try(:mayo_pilot?) && member.onboarding_group.try(:provider)
        Mails::MayoPilotInviteJob.create(member.id, member.onboarding_group.provider.id)
      end
    end
  end

  def send_confirm_email_email(member)
    return unless member.trial? && member.previous_changes[:status]
    if (member.email_confirmed == false) && member.email_confirmation_token
      UserMailer.delay.confirm_email_email(member.id)
    end
  end

  def set_self_owner(member)
    return if member.owner_id
    member.update_attribute(:owner_id, member.id)
  end
end
