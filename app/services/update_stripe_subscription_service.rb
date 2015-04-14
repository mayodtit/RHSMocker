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

  def when_to_run
    load_subscription!
    DateTime.strptime(@subscription.current_period_end.to_s, '%s')
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

  def upgrade_subscription
    redeem_coupon
    load_subscription!
    @subscription.plan = @plan_id
    @subscription.prorate = true
    @subscription.save
  end

  def downgrade_subscription
    redeem_coupon
    load_subscription!
    @subscription.plan = @plan_id
    @subscription.prorate = false
    @subscription.save
    @run_at = DateTime.strptime(@subscription.current_period_end.to_s, '%s')
  end
  handle_asynchronously :downgrade_subscription, :run_at => Proc.new { |subs|subs.when_to_run }

  def redeem_coupon
    member_discount_record = @user.discounts.find_by_redeemed_at(nil)
    if member_discount_record
      plan = Stripe::Plan.retrieve(@plan_id)
      monthly_plan_amount = (plan.interval == 'year') ? plan.amount/12 : plan.amount
      discount_amount = String(monthly_plan_amount * (member_discount_record.discount_percent)).to_i
      if invoice_item = Stripe::InvoiceItem.create(:customer => @customer,
                                                   :amount => -discount_amount,
                                                   :currency => "usd",
                                                   :description => "Referral Discount")
        member_discount_record.update_attributes(invoice_item_id: invoice_item.id, redeemed_at: Time.now)
        if member_discount_record.referrer
          referee = User.find(member_discount_record.referee_id)
          Mails::ConfirmDiscountReceivedJob.create(@user.id, referee.id)
        else
          "need to update with another email template"
        end
      end
    end
  end
end
