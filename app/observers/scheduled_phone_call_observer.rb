class ScheduledPhoneCallObserver < ActiveRecord::Observer
  def after_save(spc)
    if spc.user && (spc.state_changed? || spc.scheduled_at_changed?)
      spc.user.inbound_scheduled_communications.hold_scheduled!
    end
  end
end
