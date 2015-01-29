class Api::V1::PlansController < Api::V1::ABaseController
  before_filter :load_plans!, :only => :index
  before_filter :load_user!, :load_available_plans!, :only => :available_options

  def index
    render_success(plans: @plans,
                   text_header: text_header)
  end

  def available_options
    render_success(available_plans: @available_plans)
  end

  private

  def load_available_plans!
    @available_plans = []
    Stripe::Plan.all.each do |plan|
      if plan.metadata[:active] == 'true'
        if (current_user.stripe_customer_id) && (Stripe::Customer.retrieve(@user.stripe_customer_id).subscriptions.count > 0)
          @available_plans << plan if plan.amount > Stripe::Customer.retrieve(@user.stripe_customer_id).subscriptions.data[0].plan.amount
        else
          @available_plans << plan
        end
      end
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
