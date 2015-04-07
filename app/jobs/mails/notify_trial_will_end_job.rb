class Mails::NotifyTrialWillEndJob < Struct.new(:event)
  def self.create(event)
    Delayed::Job.enqueue(new(event))
  end

  def perform
    customer = event.data.object.customer
    user = User.find_by_stripe_customer_id(customer)
    return if user.nil?
    return if user.pha.nil?
    RHSMailer.notify_trial_will_end(user, customer).deliver
  end
end
