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
    'Your Charge Failed! Pay your money,man! Require Copy!'
  end
end