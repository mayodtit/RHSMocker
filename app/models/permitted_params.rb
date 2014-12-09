class PermittedParams < Struct.new(:params, :current_user, :subject)
  def user
    user_params.permit(*user_attributes).tap do |attributes|
      attributes.merge!(client_data: user_params[:client_data])
    end
  end

  def secure_user
    user_params.permit(*secure_user_attributes)
  end

  def association
    params.require(:association).permit(*association_attributes)
  end

  def permission
    params.require(:permission).permit(*permission_attributes)
  end

  def phone_call
    params.require(:phone_call).permit(:user_id,
                                       :origin_phone_number,
                                       :destination_phone_number,
                                       :to_role_id)
  end

  def onboarding_group
    params.require(:onboarding_group).permit(:name,
                                             :premium,
                                             :free_trial_days,
                                             :absolute_free_trial_ends_at,
                                             :mayo_pilot,
                                             :npi_number)
  end

  def referral_code
    params.require(:referral_code).permit(:name, :code, :onboarding_group_id)
  end

  def address
    params.require(:address).permit(*address_attributes)
  end

  def user_request
    params.require(:user_request)
          .permit(*user_request_attributes).tap do |attributes|
      attributes[:request_data] = params[:user_request][:request_data] if params[:user_request][:request_data]
    end
  end

  def user_image
    params.require(:user_image).permit(:image)
  end

  def height
    params.require(:height).permit(:amount, :taken_at, :healthkit_uuid, :healthkit_source)
  end

  def weight
    params.require(:weight).permit(:amount, :bmi, :taken_at, :healthkit_uuid, :healthkit_source)
  end

  def blood_pressure
    params.require(:blood_pressure).permit(:user_id, :collection_type_id, :diastolic, :systolic, :pulse, :taken_at, :healthkit_uuid, :healthkit_source)
  end

  def pha_profile
    params.require(:pha_profile).permit(:user_id, :bio_image, :weekly_capacity, :capacity_weight, :mayo_pilot_capacity_weight)
  end

  def scheduled_message
    params.require(:scheduled_message).permit(:sender_id, :recipient_id, :text, :state_event, :publish_at, :content_id)
  end

  def scheduled_communication
    params.require(:scheduled_communication).permit(:sender_id, :recipient_id, :state_event, :publish_at)
  end

  def message_template
    params.require(:message_template).permit(:name, :text)
  end

  def enrollment
    params.fetch(:enrollment, {}).permit(:email, :first_name, :last_name, :birth_date, :advertiser_id, :time_zone, :password, :code)
  end

  def insurance_policy
    params.require(:insurance_policy).permit(*insurance_policy_attributes)
  end

  private

  def user_request_attributes
    %w(user_id subject_id name user_request_type_id)
  end

  def user_params
    params.fetch(:user){params.require(:member)}
  end

  def user_attributes
    base_user_attributes.tap do |attributes|
      if !current_user
        attributes.concat(secure_user_attributes)
        attributes << {user_agreements_attributes: [:agreement_id, :ip_address, :user_agent]}
      elsif current_user != subject
        attributes << :email
      end

      if current_user && current_user.care_provider?
        attributes << :on_call
      end

      if current_user && current_user.pha?
        attributes << :pha_id
        attributes << :due_date
        attributes << {user_information_attributes: user_information_attributes}
        attributes << {insurance_policies_attributes: insurance_policy_attributes}
        attributes << {provider_attributes: provider_attributes}
        attributes << {emergency_contact_attributes: emergency_contact_attributes}
      end

      if current_user && current_user.admin?
        attributes << :pha_id
        attributes << :status_event
        attributes.concat(%i(is_premium free_trial_ends_at))
      end

      if current_user
        attributes << {addresses_attributes: address_attributes}
      end
    end
  end

  def base_user_attributes
    [:id, :first_name, :last_name, :avatar, :gender, :birth_date,
     :phone, :blood_type, :holds_phone_in, :diet_id, :ethnic_group_id,
     :deceased, :date_of_death, :npi_number, :expertise, :city, :state, :units,
     :nickname, :work_phone_number, :text_phone_number, :provider_taxonomy_code, :actor_id, :nux_answer_id,
     :payment_token]
  end

  def secure_user_attributes
    if !current_user || current_user == subject
      [:email, :password]
    else
      nil
    end
  end

  def user_information_attributes
    [:id, :notes, :highlights]
  end

  def address_attributes
    %i(id address address2 line1 line2 city state postal_code name type)
  end

  def insurance_policy_attributes
    [:id, :company_name, :plan_type, :policy_member_id, :notes]
  end

  def provider_attributes
    [:id, :address, :city, :state, :postal_code, :phone]
  end

  def emergency_contact_attributes
    [:id, :name, :phone_number, :designee_id]
  end

  def association_attributes
    if params.require(:association)[:id]
      [:association_type, :association_type_id, :is_default_hcp, :state_event,
       :invite]
    else
      [:id, :user, :user_id, :associate, :associate_id, :creator, :creator_id,
       :association_type, :association_type_id, :is_default_hcp,
       :state_event, :invite].tap do |attributes|
        attributes << {associate_attributes: user_attributes.concat([:owner, :owner_id, :self_owner])}
      end
    end
  end

  def permission_attributes
    [:basic_info, :medical_info, :care_team]
  end
end
