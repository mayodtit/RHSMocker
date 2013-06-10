class Api::V1::UserWeightsController < Api::V1::ABaseController
  def create
    if params[:user_id].present?
      user = User.find_by_id(params[:user_id]) 
      return render_failure({reason:"User with id #{params[:user_id]} is not found"}, 404) unless user
      return render_failure({reason:"Permission denied to edit user with id #{params[:user_id]}"}) unless current_user.allowed_to_edit_user?(params[:user_id])
    else
      user = current_user
    end
    user_weight = UserWeight.create(weight:params[:weight], taken_at:params[:taken_at], user:user)
    
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
    if user_weight.user_id!=current_user.id && !current_user.allowed_to_edit_user?(user_weight.user_id) && !current_user.hcp?
      return render_failure({reason:"Permission denied to delete user_weight with id #{params[:user_weight][:id]}"})
    end
    if UserWeight.destroy(user_weight.id)
      render_success
    else
      render_failure({reason:user_weight.errors.full_messages.to_sentence}, 422)
    end
  end
end
