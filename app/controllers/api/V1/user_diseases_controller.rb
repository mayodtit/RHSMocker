class Api::V1::UserDiseasesController < Api::V1::ABaseController
  before_filter :check_disease, :only=>[:create, :update, :remove]

  def create
    return render_failure({reason:"Disease_id not supplied"}, 412) unless params[:user_disease][:disease_id].present?
    disease = Disease.find_by_id params[:user_disease][:disease_id]
    return render_failure({reason:"Disease with id #{params[:user_disease][:disease_id]} is not found"}, 404) unless disease
    if params[:user_id].present?
      user = User.find_by_id params[:user_id]
      return render_failure({reason:"User with id #{params[:user_id]} is not found"}, 404) unless user
      return render_failure({reason:"Permission denied to edit user with id #{params[:user_id]}"}) unless current_user.allowed_to_edit_user?(params[:user_id])
    else
      user = current_user
    end
    user_disease = UserDisease.create params[:user_disease].merge({:user=>user})
    if user_disease.errors.empty?
      render_success({user_disease:user_disease})
    else
      render_failure( {reason:user_disease.errors.full_messages.to_sentence}, 422 )
    end
  end


  def index
    render_success({user_diseases:current_user.user_diseases})
  end

  def update
    return render_failure({reason:"UserDisease id not supplied"}, 412) unless params[:user_disease][:id].present?
    user_disease = UserDisease.find_by_id params[:user_disease][:id]
    return render_failure({reason:"UserDisease with id #{params[:user_disease][:id]} is not found"}, 404) unless user_disease
    if user_disease.user_id!=current_user.id && !current_user.allowed_to_edit_user?(user_disease.user_id)
      return render_failure({reason:"Permission denied to edit user_disease with id #{params[:user_disease][:id]}"})
    end

    if(user_disease.update_attributes params[:user_disease])
      render_success({user_disease:user_disease})
    else
      render_failure({reason:user_disease.errors.full_messages.to_sentence}, 422)
    end
  end

  def remove
    return render_failure({reason:"UserDisease id not supplied"}, 412) unless params[:user_disease][:id].present?
    user_disease = UserDisease.find_by_id params[:user_disease][:id]
    return render_failure({reason:"UserDisease with id #{params[:user_disease][:id]} is not found"}, 404) unless user_disease
    if user_disease.user_id!=current_user.id && !current_user.allowed_to_edit_user?(user_disease.user_id) && !current_user.hcp?
      return render_failure({reason:"Permission denied to delete user_disease with id #{params[:user_disease][:id]}"})
    end

    if UserDisease.destroy(user_disease.id)
      render_success
    else
      render_failure({reason:user_disease.errors.full_messages.to_sentence}, 422)
    end
  end

  def check_disease
    return render_failure({reason:"user_disease not supplied"}, 412) unless params[:user_disease].present?
  end

end
