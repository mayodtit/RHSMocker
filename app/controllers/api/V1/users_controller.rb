class Api::V1::UsersController < Api::V1::ABaseController
  before_filter :load_user!, only: %i(show update)
  before_filter :update_session_queue!, only: :update

  def show
    render_success(user: @user.serializer(serializer_options),
                   member: @user.serializer(serializer_options))
  end

  def update
    if @user.update_attributes(update_params)
      @user = User.find(@user.id) # force reload of CarrierWave image for correct URL
      render_success(user: @user.serializer(serializer_options),
                     member: @user.serializer(serializer_options))

    else
      render_failure({reason: error_reason_string}, 422)
    end
  end

  def invite
    @user = User.find(params[:id])
    @member = @user.member || Member.create_from_user!(@user, current_user)
    current_user.invitations.create(invited_member: @member) # fail silently, always return success
    render_success
  end

  private

  def user_params
    params.fetch(:member){params.require(:user)}
  end

  def load_user!
    @user = if params[:id] == 'current'
              current_user
            else
              User.find(params[:id])
            end
    authorize! :manage, @user
  end

  def update_session_queue!
    return unless current_session
    return unless @user == current_user
    return unless current_user.care_provider?
    return unless user_params[:queue_mode]
    return if current_session.queue_mode == user_params[:queue_mode]
    current_session.update_attributes!(queue_mode: user_params[:queue_mode])
  end

  def update_params
    permitted_params(@user).user.tap do |attrs|
      # decode images
      attrs[:avatar] = decode_b64_image(user_params[:avatar]) if user_params[:avatar]

      # rename hashes for nested_attributes
      attrs[:user_information_attributes] = user_params[:user_information] if user_params[:user_information]
      attrs[:insurance_policy_attributes] = user_params[:insurance_policy] if user_params[:insurance_policy]
      attrs[:provider_attributes] = user_params[:provider] if user_params[:provider]
      attrs[:emergency_contact_attributes] = user_params[:emergency_contact] if user_params[:emergency_contact]

      # allow multiple ways to set addresses
      if user_params[:address]
        attrs[:address_attributes] = PermittedParams.new(user_params, current_user, nil).address
        attrs[:addresses_attributes] = [attrs[:address_attributes]]
      end

      # set attributes
      attrs[:user_agreements_attributes] = user_agreements_attributes if user_params[:tos_checked] || user_params[:agreement_id]
      attrs[:time_zone] = params[:device_properties].try(:[], :device_timezone) if @user == current_user
      attrs[:actor_id] = current_user.try(:id)
    end
  end

  def serializer_options
    {}.tap do |options|
      if current_user.care_provider? || current_user.admin?
        options[:include_roles] = true
        options[:include_nested_information] = true
        options[:include_onboarding_information] = true
      end
    end
  end

  def error_reason_string
    if @user.errors[:phone_numbers].any?
      @association = current_user.associations.find_by_associate_id(@user.id)
      if @association.try(:association_type).try(:hcp?)
        return "Care Team Member's phone number is invalid"
      elsif @association.try(:association_type).try(:family?)
        return "Family Member's phone number is invalid"
      else
        return "Phone number is invalid"
      end
    end
    @user.errors.full_messages.to_sentence
  end
end
