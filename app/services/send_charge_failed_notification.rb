class SendChargeFailedNotification
  def initialize(event)
    @event = event
  end

  def call
    load_user!
    unless @user.delinquent
      RHSMailer.notify_user_when_first_charge_fail(@event, @user).deliver
      Notifications::UserFirstChargeFailedJob.create(@user.id)
      @user.update_attributes(:delinquent => true)
    end
  end

  private

  def load_user!
    customer = Stripe::Customer.retrieve(@event.data.object.customer)
    @user = User.find_by_stripe_customer_id(customer.id)
  end
end