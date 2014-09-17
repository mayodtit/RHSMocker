class ScheduledPhoneCallObserver < ActiveRecord::Observer
  def after_save(spc)
    hold_scheduled_communications(spc)
    create_engagement_task(spc)
  end

  def hold_scheduled_communications(spc)
    if spc.user && (spc.state_changed? || spc.scheduled_at_changed?)
      spc.user.inbound_scheduled_communications.hold_scheduled!
    end
  end

  def create_engagement_task(spc)
    if spc.state_changed? && spc.booked?
      MemberTask.create(title: 'PHA introduction',
                        description: 'Welcome call booked, do PHA introduction',
                        due_at: Time.now + 1.hour,
                        service_type: ServiceType.find_by_name('member onboarding'),
                        member: spc.user,
                        subject: spc.user,
                        owner: spc.user.pha,
                        creator: Member.robot,
                        assignor: Member.robot)
    end
  end
end
