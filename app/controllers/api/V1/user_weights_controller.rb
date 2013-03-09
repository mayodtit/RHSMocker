class Api::V1::UserWeightsController < Api::V1::ABaseController
  def create
    UserWeight.create(weight:params[:weight], user:current_user)
    render_success
  end

  def list
    render_success current_user.user_weights
  end
end