class NotifyTrialWillEndService
  def initialize(event)
    @event = event
    @customer = event.data.object.customer
  end

  def call
    subscription = Stripe::Customer.retrieve(@customer).subscriptions.data[0]
    Mails::NotifyTrialWillEndJob.create(@event) unless subscription.cancel_at_period_end
  end
end