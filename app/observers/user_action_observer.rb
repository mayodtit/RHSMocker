class UserActionObserver < ActiveRecord::Observer
  observe :message, :phone_call, :user_request

  def after_create(observed)
    if observed.user
      observed.user.inbound_scheduled_communications.hold_scheduled!
    end
  end
end
