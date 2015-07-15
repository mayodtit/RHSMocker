class Api::V1::OnboardingController < Api::V1::ABaseController
  skip_before_filter :authentication_check

  def email_validation
    if @user = Member.find_by_email(params[:email])
      render_success(requires_sign_up: false, onboarding_group: onboarding_group_for_onboarding)
    else
      render_success(requires_sign_up: true)
    end
  end

  def sign_up
    sign_up_response = SignUpService.new(sign_up_params, sign_up_options).call
    if sign_up_response[:success]
      render_success(user: sign_up_response[:user].serializer,
                     member: sign_up_response[:user].serializer,
                     pha_profile: sign_up_response[:user].pha.try(:pha_profile).try(:serializer),
                     auth_token: sign_up_response[:session].auth_token)
    else
      render_failure({reason: sign_up_response[:reason],
                      user_message: sign_up_response[:reason]}, 422)
    end
  end

  def referral_code_validation
    @referral_code = ReferralCode.find_by_code!(params[:code])
    if @referral_code.onboarding_group.try(:skip_credit_card?)
      render_success(skip_credit_card: true)
    else
      render_success(skip_credit_card: false)
    end
  end

  private

  def onboarding_group_for_onboarding
    if onboarding_group = @user.onboarding_group
      onboarding_group.serializer(for_onboarding: true).as_json
    else
      nil
    end
  end

  def sign_up_params
    {
      user: sign_up_user_params,
      subscription: {
        payment_token: user_params[:payment_token]
      }
    }
  end

  def sign_up_options
    {
      send_download_link: params[:send_download_link].present?,
    }
  end

  def user_params
    params.fetch(:user){params.require(:member)}
  end

  def sign_up_user_params
    permitted_params.user.tap do |attrs|
      # decode images
      attrs[:avatar] = decode_b64_image(user_params[:avatar]) if user_params[:avatar]

      # rename hashes for nested_attributes
      attrs[:user_information_attributes] = user_params[:user_information] if user_params[:user_information]
      attrs[:insurance_policy_attributes] = user_params[:insurance_policy] if user_params[:insurance_policy]
      attrs[:provider_attributes] = user_params[:provider] if user_params[:provider]
      attrs[:emergency_contact_attributes] = user_params[:emergency_contact] if user_params[:emergency_contact]

      # allow multiple ways to set addresses
      attrs[:address_attributes] = user_params[:address] if user_params[:address]
      attrs[:addresses_attributes] = [attrs[:address_attributes]] if attrs[:address_attributes]

      # set sign up attributes
      attrs[:user_agreements_attributes] = user_agreements_attributes if user_params[:tos_checked] || user_params[:agreement_id]
      attrs[:referral_code] = ReferralCode.find_by_code(user_params[:code]) if user_params[:code]
      attrs[:onboarding_group] = attrs[:referral_code].try(:onboarding_group)
      attrs[:enrollment] = Enrollment.find_by_token(user_params[:enrollment_token]) if user_params[:enrollment_token]

      # set device attributes
      attrs[:time_zone] = params[:device_properties].try(:[], :device_timezone)
      attrs[:actor_id] = current_user.try(:id)
    end
  end

  def user_agreements_attributes
    return [] unless Agreement.active
    if user_params[:agreement_id]
      [
        {
          agreement_id: user_params[:agreement_id],
          ip_address: request.remote_ip,
          user_agent: request.env['HTTP_USER_AGENT']
        }
      ]
    elsif user_params[:tos_checked] && Metadata.allow_tos_checked?
      [
        {
          agreement_id: Agreement.active.id,
          ip_address: request.remote_ip,
          user_agent: request.env['HTTP_USER_AGENT']
        }
      ]
    end
  end
end
