class MemberObserver < ActiveRecord::Observer
  def after_commit(member)
    add_automated_communication_workflows(member)
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
        communication_workflow_template(member.nux_answer).try(:add_to_member, member)
      end
    end
  end

  def communication_workflow_template(nux_answer)
    case nux_answer.try(:name)
    when 'childcare', 'eldercare'
      CommunicationWorkflow.automated_onboarding_caring_for
    when 'conception'
      CommunicationWorkflow.automated_onboarding_conception
    when 'pregnancy'
      CommunicationWorkflow.automated_onboarding_pregnancy
    when 'weightloss'
      CommunicationWorkflow.automated_onboarding_weightloss
    else
      CommunicationWorkflow.automated_onboarding_something_else
    end
  end

  def set_self_owner(member)
    return if member.owner_id
    member.update_attribute(:owner_id, member.id)
  end
end
