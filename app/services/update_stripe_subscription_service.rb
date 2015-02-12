class UpdateStripeSubscriptionService
  def initialize(user, plan_id)
    @user = user
    @plan_id = plan_id
  end

  def call
    if upgrade_or_downgrade == :upgrade
      upgrade_subscription
    else
      downgrade_subscription
    end
  end

  private

  def load_stripe_customer!
    @customer ||= Stripe::Customer.retrieve(@user.stripe_customer_id)
  end

  def load_subscription!
    load_stripe_customer!
    @subscription = @customer.subscriptions.first
  end

  def load_current_plan_id!
    load_subscription!
    @current_plan_id = @subscription.plan.id
  end

  def upgrade_or_downgrade
    load_current_plan_id!
    #now, no yearly to monthly upgrade or downgrade, so just compare the price
    # upgrade_patten = [['bp10', 'bp20'], ['bp10', 'bp50'], ['bp10', 'bpYRSingle192'], ['bp10', 'bpYRFamily480'],
    #                   ['bp20', 'bp50'], ['bp20', 'bpYRSingle192'], ['bp20', 'bpYRFamily480'], ['bp50', 'bpYRSingle192'],
    #                   ['bp50', 'bpYRFamily480'], ['bpYRSingle192', 'bpYRFamily480']]
    #left here as a reference
    if Stripe::Plan.retrieve(@plan_id).amount > Stripe::Plan.retrieve(@current_plan_id).amount
      :upgrade
    else
      :downgrade
    end
  end

  def local_attributes
    {   status: 'active',
        customer: @customer,
        cancel_at_period_end: false,
        quantity: 1,
        user_id: @user.id,
        plan: Stripe::Plan.retrieve(@plan_id).to_hash,
        is_current: true
    }
  end

  def upgrade_subscription
    @user.subscriptions.last.update_attributes(:is_current => false)
    @user.subscriptions.create(local_attributes)
    load_subscription!
    @subscription.plan = @plan_id
    @subscription.prorate = true
    @subscription.save
  end

  def downgrade_subscription
    @user.subscriptions.create(local_attributes.tap{|attribute|attribute[is_current] = false} )
    load_subscription!
    @subscription.plan = @plan_id
    @subscription.prorate = false
    @subscription.save
  end
end
