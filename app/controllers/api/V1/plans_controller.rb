class Api::V1::PlansController < Api::V1::ABaseController
  before_filter :load_plans!

  def index
    index_resource(@plans)
  end

  private

  def load_plans!
    @plans = Stripe::Plan.all.inject([]) do |array, plan|
      if plan.metadata[:active] == 'true'
        array << StripeExtension.plan_serializer(plan)
      end
      array
    end
  end
end
