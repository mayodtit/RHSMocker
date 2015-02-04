class SetDelinquentStatus
  def initialize(event)
    @event = event
  end

  def call
    customer = Stripe::Customer.retrieve(@event.data.object.customer)
    user = User.find_by_stripe_customer_id(customer.id)
    return if user.nil?
    if @event.type == 'charge.succeeded'
      user.update_attributes(:delinquent => false)
    else
      user.update_attributes(:delinquent => true)
    end
  end
end