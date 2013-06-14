class Api::V1::UserDiseaseTreatmentsController < Api::V1::ABaseController
  before_filter :check_treatment, :only=>[:create, :update, :remove]

  def create
    return render_failure({reason:"Treatment_id not supplied"}, 412) unless params[:user_disease_treatment][:treatment_id].present?
    treatment = Treatment.find_by_id params[:user_disease_treatment][:treatment_id]
    return render_failure({reason:"Treatment with id #{params[:user_disease_treatment][:treatment_id]} is not found"}, 404) unless treatment
    
    user_disease_treatment = UserDiseaseTreatment.create params[:user_disease_treatment].merge({:user=>current_user})
    if user_disease_treatment.errors.empty?
      render_success({user_disease_treatment:user_disease_treatment})
    else
      render_failure( {reason:user_disease_treatment.errors.full_messages.to_sentence}, 422 )
    end
  end


  def list
    render_success({user_disease_treatments:current_user.user_disease_treatments})
  end

  def update
    return render_failure({reason:"UserDiseaseTreatment id not supplied"}, 412) unless params[:user_disease_treatment][:id].present?
    user_disease_treatment = UserDiseaseTreatment.find_by_id params[:user_disease_treatment][:id]
    return render_failure({reason:"UserDiseaseTreatment with id #{params[:user_disease_treatment][:id]} is not found"}, 404) unless user_disease_treatment
    if user_disease_treatment.user_id!=current_user.id && !current_user.hcp?
      return render_failure({reason:"Permission denied to edit user_disease_treatment with id #{params[:user_disease_treatment][:id]}"})
    end

    if params['user_disease_treatment']['side_effects_attributes']
      link_side_effects(user_disease_treatment, params['user_disease_treatment']['side_effects_attributes'].map{|x| x[:id]})
      params['user_disease_treatment']['user_disease_treatment_side_effects_attributes'] = params['user_disease_treatment']['side_effects_attributes']
      params['user_disease_treatment'].delete('side_effects_attributes')
    end

    if(user_disease_treatment.update_attributes params[:user_disease_treatment])
      render_success({user_disease_treatment:user_disease_treatment})
    else
      render_failure({reason:user_disease_treatment.errors.full_messages.to_sentence}, 422)
    end
  end

  def remove
    return render_failure({reason:"UserDiseaseTreatment id not supplied"}, 412) unless params[:user_disease_treatment][:id].present?
    user_disease_treatment = UserDiseaseTreatment.find_by_id params[:user_disease_treatment][:id]
    return render_failure({reason:"UserDiseaseTreatment with id #{params[:user_disease_treatment][:id]} is not found"}, 404) unless user_disease_treatment
    if user_disease_treatment.user_id!=current_user.id && !current_user.hcp?
      return render_failure({reason:"Permission denied to edit user_disease_treatment with id #{params[:user_disease_treatment][:id]}"})
    end

    if UserDiseaseTreatment.destroy(user_disease_treatment.id)
      render_success
    else
      render_failure({reason:user_disease_treatment.errors.full_messages.to_sentence}, 422)
    end
  end

  def check_treatment
    return render_failure({reason:"user_disease_treatment not supplied"}, 412) unless params[:user_disease_treatment].present?
  end

  private

  def link_side_effects(user_disease_treatment, ids)
    ids.each do |id|
      UserDiseaseTreatmentSideEffect.find_or_create_by_user_disease_treatment_id_and_side_effect_id(user_disease_treatment.id, id)
    end
  end
end
