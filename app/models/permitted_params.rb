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

  def phone_number
    params.require(:phone_number).permit(:number,
                                         :type,
                                         :primary)
  end

  def onboarding_group
    params.require(:onboarding_group).permit(:name,
                                             :premium,
                                             :free_trial_days,
                                             :absolute_free_trial_ends_at,
                                             :mayo_pilot,
                                             :npi_number,
                                             :subscription_days,
                                             :absolute_subscription_ends_at,
                                             :skip_credit_card,
                                             :skip_emails)
  end

  def referral_code
    params.require(:referral_code).permit(:name, :code, :onboarding_group_id)
  end

  def address
    params.require(:address).permit(*address_attributes)
  end

  def appointment_template
    params.require(:appointment_template).permit(:title, :description, :scheduled_at, :state_event, :special_instructions, :reason_for_visit, scheduled_at_system_event_template_attributes: [:id, :title], discharged_at_system_event_template_attributes: [:id, :title])
  end

  def user_request
    params.require(:user_request)
          .permit(*user_request_attributes).tap do |attributes|
      attributes[:request_data] = params[:user_request][:request_data] if params[:user_request][:request_data]
    end
  end

  def user_image
    params.permit(:image, :client_guid)
  end

  def height
    params.require(:height).permit(:amount, :taken_at, :healthkit_uuid, :healthkit_source)
  end

  def weight
    params.require(:weight).permit(:amount, :taken_at, :healthkit_uuid, :healthkit_source)
  end

  def discounts
    params.require(:discounts).permit(:user_id, :referral_code_id, :coupon, :redeemed_at, :referrer)
  end

  def blood_pressure
    params.require(:blood_pressure).permit(:user_id, :collection_type_id, :diastolic, :systolic, :pulse, :taken_at, :healthkit_uuid, :healthkit_source)
  end

  def pha_profile
    params.require(:pha_profile).permit(:user_id, :bio_image, :weekly_capacity, :capacity_weight, :mayo_pilot_capacity_weight)
  end

  def scheduled_message
    params.require(:scheduled_message).permit(:sender_id, :recipient_id, :text, :state_event, :publish_at, :content_id, :service_id)
  end

  def scheduled_communication
    params.require(:scheduled_communication).permit(:sender_id, :recipient_id, :state_event, :publish_at)
  end

  def message
    params.require(:message).permit(:text, :image, :content_id, :symptom_id, :condition_id, :service_id, :note)
  end

  def message_template
    params.require(:message_template).permit(:name, :text)
  end

  def enrollment
    params.fetch(:enrollment, {}).permit(:email, :first_name, :last_name, :birth_date, :advertiser_id, :time_zone, :password, :code)
  end

  def insurance_policy
    params.require(:insurance_policy).permit(:id, :company_name, :plan_type, :plan, :subscriber_name, :family_individual, :employer_exchange,
                                             :group_number, :effective_date, :termination_date, :member_services_number, :authorized, :policy_member_id, :notes,
                                             :insurance_card_front_client_guid, :insurance_card_back_client_guid)
  end

  def service_template
    params.require(:service_template).permit(:name, :title, :description, :service_type_id, :time_estimate, :state_event)
  end

  def modal_template
    params.require(:modal_template).permit(:title, :description, :accept, :reject)
  end

  def service_template_attributes
    params.require(:service_template).permit(:service_template_id, :name, :title, :description, :subject_id, :owner_id, :service_type, :service_type_id, :time_estimate, :member_id, :user_facing, :service_request, :service_deliverable, :service_update, :unique_id, :state_event, :timed_service)
  end

  def service_attributes
    params.require(:service).permit(:title, :description, :due_at, :time_zone, :state_event, :owner_id, :reason, :reason_abandoned, :member_id,
                                    :subject_id, :service_type_id, :user_facing, :service_request, :service_deliverable, :service_update)
  end

  def task_template
    params.require(:task_template).permit(:name, :title, :service_template, :service_template_id, :task_category_id, :description, :time_estimate, :service_ordinal, :modal_template_id, :queue)
  end

  def task_step_template
    params.require(:task_step_template).permit(:description, :ordinal, :details, :template)
  end

  def system_event_template
    params.require(:system_event_template).permit(:title, :description, :state, time_offset_attributes: %i(id offset_type direction absolute_minutes relative_days relative_minutes_after_midnight))
  end

  def system_action_template_attributes
    params.require(:system_action_template).permit(:type, :message_text, :content, :content_id, :system_event_template, :system_event_template_id)
  end

  def data_field_template
    params.require(:data_field_template).permit(:name, :type, :required_for_service_start)
  end

  def feature_flag
    params.require(:feature_flag).permit(:enabled)
  end

  def task_step
    params.require(:task_step).permit(:completed)
  end

  def data_field
    params.require(:data_field).permit(:data)
  end

  def suggested_service
    params.require(:suggested_service).permit(:title, :description, :message, :service_type_id, :state_event, :user_facing)
  end

  private

  def user_request_attributes
    %w(user_id subject_id name user_request_type_id)
  end

  def user_params
    if params[:member].try(:present?)
      params.fetch(:member){params.require(:user)} # only prefer member when not empty
    else
      params.fetch(:user){params.require(:member)}
    end
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
    [:first_name, :last_name, :avatar, :gender, :birth_date,
     :phone, :blood_type, :holds_phone_in, :diet_id, :ethnic_group_id,
     :deceased, :date_of_death, :npi_number, :expertise, :units,
     :nickname, :work_phone_number, :text_phone_number, :provider_taxonomy_code,
     :actor_id, :nux_answer_id, :payment_token, :kinsights_token]
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
