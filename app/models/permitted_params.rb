class PermittedParams < Struct.new(:params, :current_user, :subject)
  def user
    user_params.permit(*user_attributes).tap do |attributes|
      attributes.merge!(client_data: user_params[:client_data])
      if !current_user && user_params[:waitlist_entry]
        attributes.merge!(waitlist_entry: user_params[:waitlist_entry])
      end
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
                                             :absolute_free_trial_ends_at)
  end

  private

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

      if current_user && current_user.pha?
        attributes << :pha_id
        attributes << {user_information_attributes: user_information_attributes}
        attributes << {insurance_policy_attributes: insurance_policy_attributes}
        attributes << {provider_attributes: provider_attributes}
        attributes << {emergency_contact_attributes: emergency_contact_attributes}
      end

      if current_user
        attributes << {address_attributes: address_attributes}
      end
    end
  end

  def base_user_attributes
    [:id, :first_name, :last_name, :avatar, :gender, :height, :birth_date,
     :phone, :blood_type, :holds_phone_in, :diet_id, :ethnic_group_id,
     :deceased, :date_of_death, :npi_number, :expertise, :city, :state, :units,
     :nickname, :work_phone_number, :provider_taxonomy_code]
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
    [:id, :address, :address2, :city, :state, :postal_code]
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
