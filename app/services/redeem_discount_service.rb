class RedeemDiscountService
  def initialize(event)
    @event = event
  end

  def call
    customer = Stripe::Customer.retrieve(find_stripe_customer_id(@event))
    member =  Member.find_by_stripe_customer_id(customer.id)
    return if member.nil?
    redeem_coupon(member, customer)
  end

  private

  def find_stripe_customer_id(event)
    event.data.object.customer
  end

  def redeem_coupon(member, customer)
    member_discount_record = member.discounts.find_by_redeemed_at(nil)
    plan = customer.subscriptions.data.first.plan
    subscription_status =  customer.subscriptions.data.first.status
    invoice = Stripe::Invoice.retrieve(@event.data.object.id)
    if member_discount_record && subscription_status == "active" && !invoice.closed
      discount_amount = calculate_discount(plan)
      if invoice_item = create_invoice_item(customer, discount_amount)
        member_discount_record.update_attributes(invoice_item_id: invoice_item.id, redeemed_at: Time.now)
        send_confirmation(member, member_discount_record)
      end
    end
  end

  def create_invoice_item(customer, discount_amount)
    Stripe::InvoiceItem.create(:customer => customer,
                               :amount => -discount_amount,
                               :currency => "usd",
                               :description => "Referral Discount")
  end

  def calculate_discount(plan)
    monthly_plan_amount = (plan.interval == 'year') ? plan.amount/12 : plan.amount
    String(monthly_plan_amount * (member_discount_record.discount_percent)).to_i
  end

  def send_confirmation(member, member_discount_record)
    if member_discount_record.referrer
      referee = User.find(member_discount_record.referee_id)
      Mails::ConfirmDiscountReceivedJob.create(member.id, referee.id)
    else
      "need to update with another email template"
    end
  end
end
