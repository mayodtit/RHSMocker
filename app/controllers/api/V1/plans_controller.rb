class Api::V1::PlansController < Api::V1::ABaseController
  before_filter :load_active_plans!
  before_filter :load_plans!, :only => :index
  before_filter :load_user!, :load_available_plans!, :only => :available_options

  def index
    render_success(plans: @plans,
                   text_header: text_header)
  end

  def available_options
    render_success(plans: @available_plans,
                   text_header: available_options_text_header)
  end

  private

  def load_available_plans!
    @available_plans = []
    @active_plans.each do |plan|
      if (current_user.stripe_customer_id) && (Stripe::Customer.retrieve(@user.stripe_customer_id).subscriptions.count > 0)
        @available_plans << StripeExtension.plan_serializer(plan, current_user) if plan.amount > Stripe::Customer.retrieve(@user.stripe_customer_id).subscriptions.data[0].plan.amount
      else
        @available_plans << StripeExtension.plan_serializer(plan, current_user)
      end
      @available_plans
    end
  end

  def load_plans!
    @plans = @active_plans.inject([]){|array, plan|array << StripeExtension.plan_serializer(plan, current_user) }
  end

  def load_active_plans!
    @active_plans = Stripe::Plan.all.inject([]) do |array, plan|
      if plan.metadata[:active] == 'true'
        array << plan
      end
      array
    end
  end

  def text_header
    'Choose Family Membership for access to your PHA and benefits for everyone you care about. Or keep Single Membership just for you. Prepay for either yearly membership and get a discount.'
  end

  def available_options_text_header
    "needs copy"
  end
end
