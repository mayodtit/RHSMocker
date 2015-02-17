class Notifications::UserFirstChargeFailedJob < Struct.new(:user_id)
  def self.create(user_id)
    Delayed::Job.enqueue(new(user_id))
  end

  def perform
    user = User.find(user_id)
    user.sessions.where('apns_token IS NOT NULL').each do |session|
        APNS.send_notification(session.apns_token, alert: alert_text,
                               sound: :default)
    end
  end

  private

  def alert_text
    "Your credit card has been declined. To continue your Better membership please update your credit card information in the Membership section in the Settings of [Health Profile](better://nb?cmd=showProfile) within the next 5 days, or your subscription will be canceled."
  end
end

