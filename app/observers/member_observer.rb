class MemberObserver < ActiveRecord::Observer
  def after_commit(member)
    add_automated_communication_workflows(member)
    set_self_owner(member)
  end

  private

  def add_automated_communication_workflows(member)
    return unless member.trial? && member.previous_changes[:status]
    return unless member.inbound_scheduled_communications.empty?
    member.transaction do
      if Metadata.automated_onboarding?
        CommunicationWorkflow.automated_onboarding.try(:add_to_member, member)
      end
      if Metadata.automated_offboarding?
        CommunicationWorkflow.automated_offboarding.try(:add_to_member, member)
      end
    end
  end

  def set_self_owner(member)
    return if member.owner_id
    member.update_attribute(:owner_id, member.id)
  end
end
