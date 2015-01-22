class TimelineObserver < ActiveRecord::Observer
  observe :note, :message, :phone_call, :scheduled_phone_call, :phone_call_summary, :task, :content, :card

  def after_create(observed)
    if observed.member
      observed.member.entries.create(resource: observed)
    elsif observed.user
      user.member.entries.create(resource: observed)
    end
  end
end
