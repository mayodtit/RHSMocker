class Api::V1::OfferingsController < Api::V1::ABaseController
  skip_before_filter :authentication_check
  before_filter :load_plan

  def index
    @offerings = offerings_scope.all
    render_success({offerings: @offerings})
  end

  def show
    @offering = offerings_scope.find(params[:id])
    render_success({offering: @offering})
  end

  private

  def load_plan
    @plan = Plan.find(params[:plan_id]) if params[:plan_id]
  end

  def offerings_scope
    @plan.try(:offerings) || Offering
  end
end
