class Api::V1::BloodPressuresController < Api::V1::ABaseController
  def index
    @blood_pressures = blood_pressure_scope.order('taken_at DESC').all
    render_success({blood_pressures: @blood_pressures})
  end

  def create

    if params[:user_id].present?
      user = User.find_by_id(params[:user_id]) 
      return render_failure({reason:"User with id #{params[:user_id]} is not found"}, 404) unless user
      return render_failure({reason:"Permission denied to edit user with id #{params[:user_id]}"}) unless current_user.allowed_to_edit_user?(params[:user_id])
    else
      user = current_user
    end
    collection_type_id = params[:collection_type_id]
    collection_type_id ||= CollectionType.find_or_create_by_name("self-reported").id

    blood_pressure = BloodPressure.create(collection_type_id:collection_type_id, diastolic:params[:diastolic], systolic:params[:systolic], pulse:params[:pulse], taken_at:params[:taken_at], user:user)
    if blood_pressure.errors.empty?
      render_success blood_pressure:blood_pressure
    else
      render_failure( {reason:blood_pressure.errors.full_messages.to_sentence}, 412 )
    end
  end

  def list
    render_success blood_pressures:current_user.blood_pressures
  end

  def remove
    blood_pressure = BloodPressure.find_by_id params[:blood_pressure][:id]
    return render_failure({reason: "Could not find blood_pressure reading with id #{params[:blood_pressure][:id]}"}, 404) unless blood_pressure
    if blood_pressure.user_id!=current_user.id && !current_user.allowed_to_edit_user?(blood_pressure.user_id) && !current_user.hcp?
      return render_failure({reason:"Permission denied to delete blood_pressure with id #{params[:blood_pressure][:id]}"})
    end
    if BloodPressure.destroy(blood_pressure.id)
      render_success
    else
      render_failure({reason:blood_pressure.errors.full_messages.to_sentence}, 422)
    end
  end

  private

  def blood_pressure_scope
    params[:user_id] ? User.find(params[:user_id]).blood_pressures : current_user.blood_pressures
  end
end
