class TimelineObserver < ActiveRecord::Observer
  observe :note, :message, :phone_call, :scheduled_phone_call, :phone_call_summary, :task

  def after_create(observed)
    if observed.respond_to?(:member)
      observed.member.entries.create(resource: observed)
    elsif observed.respond_to?(:user)
      user.member.entries.create(resource: observed)
    end
  end
end
