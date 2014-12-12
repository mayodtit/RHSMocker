class Api::V1::PlansController < Api::V1::ABaseController
  before_filter :load_plans!

  def index
    render_success(plans: @plans,
                   text_header: text_header)
  end

  private

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
