class Api::V1::PlansController < Api::V1::ABaseController
  skip_before_filter :authentication_check

  def index
    @plans = plan_scope.all
    render_success({plans: @plans})
  end

  def show
    @plan = Plan.find(params[:id])
    render_success({plan: @plan})
  end

  private

  def plan_scope
    params[:group_name] ? Plan.for_group_by_name(params[:group_name]) : Plan
  end
end
