class Notifications::WelcomeCallCompletionJob < Struct.new(:user_id)
  def self.create(user_id)
    Delayed::Job.enqueue(new(user_id))
  end

  def perform
    user = User.find(user_id)
    if user.apns_token
      APNS.send_notification(user.apns_token, alert: alert_text,
                                              badge: 1,
                                              sound: :default)
    end
  end

  private

  def alert_text
    "We enjoyed getting to know you on the Welcome call! If you'd like to " +
    "continue your Premium membership once your trial is over, simply enter " +
    "your card number under \"Payment.\""
  end
end
