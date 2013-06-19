class Api::V1::PlansController < Api::V1::ABaseController
  skip_before_filter :authentication_check
  before_filter :load_user

  def index
    @plans = plans_scope.all
    render_success({plans: @plans})
  end

  def show
    @plan = plans_scope.find(params[:id])
    render_success({plan: @plan})
  end

  private

  def load_user
    @user = User.find(params[:user_id]) if params[:user_id]
  end

  def plans_scope
    @user.try(:plans) || Plan.user_selectable
  end
end
