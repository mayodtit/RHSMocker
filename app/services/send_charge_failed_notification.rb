class SendChargeFailedNotification
  def initialize(event)
    @event = event
  end

  def call
    load_user!
    return unless @user
    unless @user.delinquent
      Mails::NotifyUserWhenFirstChargeFailJob.create(@user.id)
      Notifications::UserFirstChargeFailedJob.create(@user.id)
    end
  end

  private

  def load_user!
    customer = Stripe::Customer.retrieve(@event.data.object.customer)
    @user = User.find_by_stripe_customer_id(customer.id)
  end
end
