class Notifications::NewMessageJob < Struct.new(:user_id, :consult_id)
  def self.create(user_id, consult_id)
    job = new(user_id, consult_id)
    Delayed::Job.enqueue(job, queue: job.queue_name)
  end

  def enqueue(job)
    Delayed::Job.where(queue: job.queue).destroy_all
  end

  def perform
    user = User.find(user_id)
    if user.apns_token
      APNS.send_notification(user.apns_token, alert: 'You have a new message from a Personal Health Assistant.',
                                              badge: 1,
                                              sound: :default,
                                              other: {aps: {badge: 1,
                                                            badges: {your_pha: 1}}})
    end
  end

  def queue_name
    "NewMessageJob-UserId-#{user_id}-ConsultId-#{consult_id}"
  end
end
