class ApnsConsultMessageJob < Struct.new(:user_id, :consult_id)
  def self.create(user_id, consult_id)
    job = new(user_id, consult_id)
    Delayed::Job.enqueue(job, run_at: 5.minutes.from_now,
                              queue: job.queue_name)
  end

  def enqueue(job)
    Delayed::Job.where(queue: job.queue).destroy_all
  end

  def perform
    user = User.find(user_id)
    consult = Consult.find(consult_id)
    if user.apns_token
      APNS.send_notification(user.apns_token, alert: 'You have a new message from your Personal Health Assistant.',
                                              sound: :default,
                                              other: {nb: {cmd: 'openConsult',
                                                           args: {id: consult.id}}})
    end
  end

  def queue_name
    "ApnsConsultMessageJob-UserId-#{user_id}-ConsultId-#{consult_id}"
  end
end
