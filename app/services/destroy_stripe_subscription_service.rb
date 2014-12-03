class DestroyStripeSubscriptionService
  def initialize(user)
    @user = user
  end

  def call
    @customer ||= Stripe::Customer.retrieve(@user.stripe_customer_id)
     @customer.subscriptions.all.each do |subscription|
       subscription.delete
    end
  end
end
