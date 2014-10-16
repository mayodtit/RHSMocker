class Notifications::NewMessageJob < Struct.new(:user_id, :consult_id)
  def self.create(user_id, consult_id)
    job = new(user_id, consult_id)
    Delayed::Job.enqueue(job, queue: job.queue_name)
  end

  def perform
    user = User.find(user_id)
    apns_sessions = user.sessions.where('apns_token IS NOT NULL')
    if apns_sessions.any?
      apns_sessions.each do |session|
        APNS.send_notification(session.apns_token, alert: 'You have a new message from a Personal Health Assistant.',
                                                   badge: 1,
                                                   sound: :default,
                                                   other: {badges: {your_pha: 1}})
      end
    end

    gcm_sessions = user.sessions.where('gcm_id IS NOT NULL')
    if gcm_sessions.any?
      gcm_sessions.each do |session|
        GCM.alert_new_message(session.gcm_id)
      end
    end
  end

  def queue_name
    "NewMessageJob-UserId-#{user_id}-ConsultId-#{consult_id}"
  end
end
