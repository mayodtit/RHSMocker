class Api::V1::MembersController < Api::V1::ABaseController
  before_filter :load_members!, only: :index
  before_filter :load_member!, only: %i(show update)
  before_filter :load_member_from_login!, only: :secure_update
  before_filter :update_session_queue!, only: :update, if: :session_valid?

  def index
    render_success(users: @members.includes(:pha).serializer(list: true),
                   page: page,
                   per: per,
                   total_count: @members.total_count)
  end

  def show
    render_success(user: @member.serializer(serializer_options),
                   member: @member.serializer(serializer_options))
  end

  def update
    if @member.update_attributes(update_params)
      @member = Member.find(@member.id) # force reload of CarrierWave image for correct URL
      render_success(user: @member.serializer(serializer_options),
                     member: @member.serializer(serializer_options))
    else
      render_failure({reason: @member.errors.full_messages.to_sentence}, 422)
    end
  end

  def secure_update
    if @member.update_attributes(secure_update_params)
      render_success user: @member.serializer,
                     member: @member.serializer
    else
      render_failure({reason: @member.errors.full_messages.to_sentence}, 422)
    end
  end

  private

  def user_params
    params.fetch(:user){params.require(:member)}
  end

  def load_members!
    authorize! :index, Member
    search_params = params.permit(:pha_id, :is_premium, :status)
    if search_params.has_key?(:is_premium) && (search_params[:is_premium] == 'true')
      search_params[:status] = Member::PREMIUM_STATES
      search_params.except!(:is_premium)
    end

    @members = Member.signed_up.where(search_params).order('users.last_contact_at DESC')
    @members = @members.name_search(params[:q]) if params[:q]
    @members = @members.page(page).per(per)
  end

  def page
    params[:page] || 1
  end

  def per
    params[:per] || 50
  end

  def load_member!
    @member = if params[:id] == 'current'
                current_user
              else
                Member.find(params[:id])
              end
    authorize! :manage, @member
  end

  def load_member_from_login!
    @member = login(current_user.email, current_pasword)
    render_failure({reason: 'Current password is invalid'}, 422) and return unless @member
    authorize! :manage, @member
  end

  def current_password
    if params[:user].try(:[], :current_password)
      params[:user][:current_password]
    elsif update_email_path?
      params[:password]
    elsif update_password_path?
      params[:current_password]
    end
  end

  def update_email_path?
    request.env['PATH_INFO'].include?('update_email')
  end

  def update_password_path?
    request.env['PATH_INFO'].include?('update_password')
  end

  def update_params
    permitted_params(@member).user.tap do |attrs|
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

      # set attributes
      attrs[:user_agreements_attributes] = user_agreements_attributes if user_params[:tos_checked] || user_params[:agreement_id]
      attrs[:time_zone] = params[:device_properties].try(:[], :device_timezone)
      attrs[:actor_id] = current_user.try(:id)
    end
  end

  def secure_update_params
    if update_email_path?
      {
        user: {
          email: params[:email]
        }
      }
    elsif update_password_path?
      {
        user: {
          password: params[:password]
        }
      }
    else
      permitted_params(@member).secure_user
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

  def session_valid?
    current_session ? true : false
  end

  def update_session_queue!
    queue_mode = params[:user].try(:[], :queue_mode)
    if @member == current_user && current_user.try(:care_provider?) && queue_mode
      if current_session.queue_mode != queue_mode
        current_session.update_attributes!(queue_mode: queue_mode)
      end
    end
  end
end
