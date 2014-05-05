class Notifications::FreeTrialExpirationJob < Struct.new(:user_id, :days_left)
  def self.create(user_id, days_left)
    job = new(user_id, days_left)
    Delayed::Job.enqueue(job, queue: job.queue_name)
  end

  def enqueue(job)
    Delayed::Job.where(queue: job.queue).destroy_all
  end

  def perform
    user = User.find(user_id)
    if user.apns_token
      APNS.send_notification(user.apns_token, alert: alert_text,
                                              sound: :default)
    end
  end

  def queue_name
    "FreeTrialExpirationJob-UserId-#{user_id}"
  end

  private

  def alert_text
    case days_left
    when 7
      'You have one week left of your free trial of Better Premium! Let ' +
      'your personal Health Assistant help you live better --start a ' +
      'conversation.'
    when 2
      'You have two days left of Better Premium. Make the most of your ' +
      'Personal Health Assistant.'
    when 1
      "Your trial ends tomorrow, but let's continue to work together: " +
      'upgrade to Better Premium.'
    else
      raise 'invalid value for days_left'
    end
  end
end
