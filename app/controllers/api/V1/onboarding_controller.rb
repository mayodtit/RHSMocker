class Api::V1::OnboardingController < Api::V1::ABaseController
  skip_before_filter :authentication_check

  def email_validation
    if @user = Member.find_by_email(params[:email])
      render_success(requires_sign_up: false,
                     skip_credit_card: onboarding_skip_credit_card?,
                     user: onboarding_user_attributes,
                     onboarding_customization: onboarding_customization,
                     onboarding_custom_welcome: onboarding_custom_welcome)
    elsif email_valid?
      render_success(requires_sign_up: true,
                     skip_credit_card: onboarding_skip_credit_card?,
                     user: onboarding_user_attributes,
                     onboarding_customization: onboarding_customization,
                     onboarding_custom_welcome: onboarding_custom_welcome)
    else
      render_failure({reason: 'Email is invalid'}, 422)
    end
  end

  def referral_code_validation
    if @referral_code = ReferralCode.find_by_code(params[:code])
      render_success(skip_credit_card: onboarding_skip_credit_card?,
                     onboarding_custom_welcome: onboarding_custom_welcome)
    else
      render_failure({ reason: 'invalid referral code',
                       user_message:'Referral code is invalid',
                       skip_credit_card: onboarding_skip_credit_card?,
                       onboarding_custom_welcome: onboarding_custom_welcome},
                     404)
    end
  end

  def log_in
    @user = login(email, password)
    render_failure({reason:"Incorrect credentials", user_message: 'Email or password is invalid'}, 401) and return unless @user
    @sessions = params[:care_portal] ? @user.care_portal_sessions : @user.sessions
    @session = @sessions.create
    if @session.errors.empty?
      render_success(user: @user.serializer(include_roles: true),
                     pha: @user.pha.try(:serializer),
                     auth_token: @session.auth_token,
                     onboarding_custom_welcome: onboarding_custom_welcome,
                     suggested_services_modal: onboarding_suggested_services_modal)
    else
      render_failure({reason: @session.errors.full_messages.to_sentence}, 422)
    end
  end

  def sign_up
    sign_up_response = SignUpService.new(sign_up_params, sign_up_options).call
    if sign_up_response[:success]
      @user = sign_up_response[:user]
      @session = sign_up_response[:session]
      render_success(user: @user.serializer,
                     member: @user.serializer,
                     pha_profile: @user.pha.try(:pha_profile).try(:serializer),
                     auth_token: @session.auth_token,
                     onboarding_custom_welcome: onboarding_custom_welcome,
                     suggested_services_modal: onboarding_suggested_services_modal)
    else
      render_failure({reason: sign_up_response[:reason],
                      user_message: sign_up_response[:reason]}, 422)
    end
  end

  private

  def onboarding_group_candidate
    @onboarding_group_candidate ||= OnboardingGroupCandidate.find_by_email(params[:email])
  end

  def onboarding_group
    @onboarding_group ||= @referral_code.try(:onboarding_group) || @user.try(:onboarding_group) || onboarding_group_candidate.try(:onboarding_group)
  end

  def onboarding_skip_credit_card?
    onboarding_group.try(:skip_credit_card?) ? true : false
  end

  def onboarding_user_attributes
    if @user
      {first_name: @user.first_name}
    elsif onboarding_group_candidate
      {first_name: onboarding_group_candidate.first_name}
    else
      nil
    end
  end

  def onboarding_customization
    if onboarding_group.try(:onboarding_customization?)
      onboarding_group.try(:serializer, onboarding_customization: true)
    else
      nil
    end
  end

  def onboarding_custom_welcome
    if @user && past_sessions.any?
      []
    elsif onboarding_group.try(:onboarding_custom_welcome?)
      [onboarding_group.serializer(onboarding_custom_welcome: true).as_json]
    else
      []
    end
  end

  def past_sessions
    sessions = Session.unscoped.where(member_id: @user.id)
    sessions = sessions.where('id != ?', @session.id) if @session
    sessions
  end

  def onboarding_suggested_services_modal
    if @user.messages.any?
      nil
    elsif @user.suggested_services.any?
      {
        header_text: 'To get started with a Personal Health Assistant, please select a Service.',
        suggested_services: @user.suggested_services.serializer.as_json,
        action_button_text: "LET'S GO!"
      }
    else
      nil
    end
  end

  def email
    params[:user].try(:[], :email) || params[:email]
  end

  def password
    params[:user].try(:[], :password) || params[:password]
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
    params.fetch(:member){params.require(:user)}
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
      attrs[:onboarding_group_candidate] = OnboardingGroupCandidate.find_by_email(user_params[:email])
      attrs[:onboarding_group] = attrs[:referral_code].try(:onboarding_group) || attrs[:onboarding_group_candidate].try(:onboarding_group)
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

  def email_valid?
    ValidateEmail.valid?(params[:email]) && ValidateEmail.mx_valid?(params[:email])
  end
end
