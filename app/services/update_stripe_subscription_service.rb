class UpdateStripeSubscriptionService
  def initialize(user, plan_id)
    @user = user
    @plan_id = plan_id
  end

  def call
    if upgrade_or_downgrade == :upgrade
      
    else

    end
  end

  private
  def load_stripe_customer!
    @customer ||= Stripe::Customer.retrieve(@user.stripe_customer_id)
  end

  def current_plan_id
    @current_plan_id = @customer.subscription.data[0].plan.id
  end

  def load_subscription!
    @customer.subscriptions.retrieve(@current_plan_id)
  end

  def upgrade_or_downgrade
    upgrade_patten = [['bp10', 'bp20'], ['bp10', 'bp50'], ['bp10', 'bpYRSingle192'], ['bp10', 'bpYRFamily480'],
                      ['bp20', 'bp50'], ['bp20', 'bpYRSingle192'], ['bp20', 'bpYRFamily480'], ['bp50', 'bpYRSingle192'],
                      ['bp50', 'bpYRFamily480'], ['bpYRSingle192', 'bpYRFamily480']]
    if upgrade_patten.include?([@current_plan_id, @plan_id])
      :upgrade
    else
      :downgrade
    end
  end
end