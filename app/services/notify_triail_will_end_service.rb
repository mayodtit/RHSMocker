class NotifyTrialWillEndService
  def initialize(event)
    @event = event
    @customer = event.data.object.customer
    @subscription_id = event.data.object.id
  end

  def call
    subscription = Stripe::Customer.retrieve(@customer).subscriptions.retrieve(@subscription_id)
    Mails::NotifyTrialWillEndJob.create(@event) unless subscription.cancel_at_period_end
  end
end
