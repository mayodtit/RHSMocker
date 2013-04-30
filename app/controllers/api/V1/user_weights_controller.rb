class Api::V1::UserWeightsController < Api::V1::ABaseController
  def create
    user_weight = UserWeight.create(weight:params[:weight], user:current_user)
    
    if user_weight.errors.empty?
      render_success user_weight:user_weight
    else
      render_failure( {reason:user_weight.errors.full_messages.to_sentence}, 412 )
    end
  end

  def list
    render_success weights:current_user.user_weights
  end

  def remove
    user_weight = UserWeight.find_by_id params[:user_weight][:id]
    return render_failure({reason: "Could not find user_weight reading with id #{params[:user_weight][:id]}"}, 404) unless user_weight
    return render_failure({reason:"Permission denied"}) unless user_weight.user==current_user
    if UserWeight.destroy(user_weight.id)
      render_success
    else
      render_failure({reason:user_weight.errors.full_messages.to_sentence}, 422)
    end
  end
end
