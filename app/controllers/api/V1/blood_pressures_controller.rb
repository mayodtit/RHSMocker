class Api::V1::BloodPressuresController < Api::V1::ABaseController
  def create
    collection_type_id = params[:collection_type_id]
    collection_type_id ||= CollectionType.find_or_create_by_name("self-reported").id

    blood_pressure = BloodPressure.create(collection_type_id:collection_type_id, diastolic:params[:diastolic], systolic:params[:systolic], pulse:params[:pulse], user:current_user)
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
    return render_failure({reason:"Permission denied"}) unless blood_pressure.user==current_user
    if BloodPressure.destroy(blood_pressure.id)
      render_success
    else
      render_failure({reason:blood_pressure.errors.full_messages.to_sentence}, 422)
    end
  end
end
