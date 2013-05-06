class Api::V1::UserAllergiesController < Api::V1::ABaseController
  
  def index
    render_success({user_allergies:current_user.user_allergies})
  end

  def create
    return render_failure( {reason:"Allergy_id not supplied"}, 412 ) unless params[:allergy_id].present?
    allergy = Allergy.find_by_id params[:allergy_id]
    return render_failure( {reason:"Allergy with id #{params[:allergy_id]} is not found"}, 404 ) unless allergy
    if params[:user_id].present?
      user = User.find_by_id params[:user_id]
      return render_failure({reason:"User with id #{params[:user_id]} is not found"}, 404) unless user
      return render_failure({reason:"Permission denied to edit user with id #{params[:user_id]}"}) unless current_user.allowed_to_edit_user?(params[:user_id])
    else
      user = current_user
    end
    user_allergy = UserAllergy.create( {:allergy=>allergy, :user=>user} )
    if user_allergy.errors.empty?
      render_success( {user_allergy:user_allergy} )
    else
      render_failure( {reason:user_allergy.errors.full_messages.to_sentence}, 412 )
    end
  end

  def remove
    return render_failure( {reason:"UserAllergy id not supplied"}, 412 ) unless params[:user_allergy_id].present?
    user_allergy = UserAllergy.find_by_id params[:user_allergy_id]
    return render_failure({reason:"user_allergy with id #{params[:user_allergy_id]} is not found"}, 404) unless user_allergy
    if user_allergy.user_id!=current_user.id && !current_user.allowed_to_edit_user?(user_allergy.user_id) && !current_user.hcp?
      return render_failure({reason:"Permission denied to edit user_allergy with id #{params[:user_allergy_id]}"})
    end

    if UserAllergy.destroy(user_allergy.id)
      render_success user_allergy:user_allergy
    else
      render_failure({reason:user_allergy.errors.full_messages.to_sentence}, 422)
    end
  end

end
