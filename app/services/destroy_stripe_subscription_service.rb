class DestroyStripeSubscriptionService
  def initialize(user, status)
    @user = user
    @status = status
  end

  def call
    @customer ||= Stripe::Customer.retrieve(@user.stripe_customer_id)
    @customer.subscriptions.all.each do |subscription|
      if @status == :upgrade
        subscription.delete
      else
        subscription.delete(at_period_end: true)
      end
    end
  end
end
