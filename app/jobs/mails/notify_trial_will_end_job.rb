class Mails::NotifyTrialWillEndJob < Struct.new(:event)
  def self.create(event)
    Delayed::Job.enqueue(new(event))
  end

  def perform
    RHSMailer.notify_trial_will_end(event).deliver
  end
end