class Api::V1::PlansController < Api::V1::ABaseController
  before_filter :load_plans!

  def index
    render_success(plan: @plans,
                   text_header: 'Please select the plan below:')
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
end
