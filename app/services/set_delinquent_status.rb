class SetDelinquentStatus
  def initialize(event)
    @event = event
  end

  def call
    load_user!
    return unless @user
    if @event.type == 'charge.succeeded'
      @user.update_attributes(:delinquent => false)
    else
      @user.update_attributes(:delinquent => true)
    end
  end

  private

  def load_user!
    customer = Stripe::Customer.retrieve(@event.data.object.customer)
    @user = User.find_by_stripe_customer_id(customer.id)
  end
end
