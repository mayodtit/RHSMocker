class DestroyStripeSubscriptionService
  def initialize(user)
    @user = user
    #set up all the things
  end

  def call
    #do the unsubscribe
    @customer ||= Stripe::Customer.retrieve(@user.stripe_customer_id)
     @customer.subscriptions.all.each do |subscription|
       subscription.delete
    end
  end
end
