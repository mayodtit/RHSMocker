class RedeemDiscountService
  def initialize(options)
    options.each{|key, value|instance_variable_set("@#{key}", value) unless value.nil?}
  end

  def call
    if @status == :recurring
      customer = Stripe::Customer.retrieve(find_stripe_customer_id(@event))
      member =  Member.find_by_stripe_customer_id(customer.id)
      return if member.nil?
      redeem_coupon(member, customer, @status)
    else
      redeem_coupon(@member, @customer, @status)
    end
  end

  private

  def redeem_coupon(member, customer, status)
    plan = @plan || customer.try(:subscriptions).try(:data).try(:first).try(:plan)
    return unless plan
    if eligible_for_discount(status, member, customer)
      discount_amount = calculate_discount(plan)
      if invoice_item = create_invoice_item(customer, discount_amount)
        @member_discount_record.update_attributes(invoice_item_id: invoice_item.id, redeemed_at: Time.now)
        send_confirmation(member, @member_discount_record)
      end
    end
  end

  def find_stripe_customer_id(event)
    event.data.object.customer
  end

  def eligible_for_discount(status, member, customer)
    @member_discount_record = member.discounts.find_by_redeemed_at(nil)
    if status == :recurring
      subscription_status =  customer.subscriptions.data.first.status
      invoice = Stripe::Invoice.retrieve(@event.data.object.id)
      @member_discount_record && subscription_status == "active" && !invoice.closed
    else
      !!@member_discount_record
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
    String(monthly_plan_amount * (@member_discount_record.discount_percent)).to_i
  end

  def send_confirmation(member, member_discount_record)
    if member_discount_record.referrer
      referee = User.find(member_discount_record.referee_id)
      Mails::ConfirmDiscountReceivedJob.create(member.id, referee.id)
    end
  end
end
