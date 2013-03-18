class Api::V1::UserWeightsController < Api::V1::ABaseController
  def create
    user_weight = UserWeight.create(weight:params[:weight], user:current_user)
    
    if user_weight.errors.empty?
      render_success
    else
      render_failure( {reason:user_weight.errors.full_messages.to_sentence}, 412 )
    end
  end

  def list
    render_success weights:current_user.user_weights
  end
end
