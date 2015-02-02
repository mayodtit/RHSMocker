class SendChargeFailedNotification
  def initialize(event)
    @event = event
  end

  def call
    customer = Stripe::Customer.retrieve(event.data.object.customer)
    user = User.find_by_stripe_customer_id(customer.id)
    unless user.delinquent
      RHSMailer.notify_user_when_first_charge_fail(@event, user).deliver
      Notifications::UserFirstChargeFailedJob.create(user.id)
      user.delinquent = true
    end
  end
end