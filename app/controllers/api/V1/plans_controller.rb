class Api::V1::PlansController < Api::V1::ABaseController
  before_filter :load_plans!

  def index
    render_success(plans: @plans,
                   text_header: text_header)
  end

  def available_plans
    render_success(available_plans: available_plans)
  end

  private

  def load_available_plans!
    subscribe_options = []
    Stripe::Plan.all.each{|plan| subscribe_options << plan }
    if current_user.stripe_customer_id
      subscribe_options.delete_if{|option| option.amount < Stripe::Customer.retrieve(current_user.stripe_customer_id).subscriptions.data[0].plan.amount}
    else
      subscribe_options
    end
  end

  def load_plans!
    @plans = Stripe::Plan.all.inject([]) do |array, plan|
      if plan.metadata[:active] == 'true'
        array << StripeExtension.plan_serializer(plan, current_user)
      end
      array
    end
  end

  def text_header
    'Choose Family Membership for access to your PHA and benefits for everyone you care about. Or keep Single Membership just for you. Prepay for either yearly membership and get a discount.'
  end
end
