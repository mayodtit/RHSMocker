class Api::V1::MembersController < Api::V1::ABaseController
  skip_before_filter :authentication_check, only: :create
  before_filter :load_members!, only: :index
  before_filter :load_member!, only: [:show, :update]
  before_filter :convert_legacy_parameters!, only: :secure_update # TODO - remove when deprecated routes are removed
  before_filter :load_member_from_login!, only: :secure_update
  before_filter :load_waitlist_entry!, only: :create
  before_filter :convert_parameters!, only: [:create, :update, :update_current]

  def index
    render_success(users: @members.serializer,
                   page: page,
                   per: per,
                   total_count: @members.total_count)
  end

  def show
    render_success user: @member.serializer(serializer_options),
                   member: @member.serializer(serializer_options)
  end

  def current
    render_success user: current_user.serializer(include_roles: true),
                   member: current_user.serializer(include_roles: true)
  end

  def create
    @member = Member.create permitted_params.user
    if @member.errors.empty?
      render_success user: @member.serializer,
                     member: @member.serializer,
                     auth_token: @member.auth_token
    else
      render_failure({reason: @member.errors.full_messages.to_sentence,
                      user_message: @member.errors.full_messages.to_sentence}, 422)
    end
  end

  def update
    if @member.update_attributes(permitted_params(@member).user)
      render_success user: @member.serializer(serializer_options),
                     member: @member.serializer(serializer_options)
    else
      render_failure({reason: @member.errors.full_messages.to_sentence}, 422)
    end
  end

  def update_current
    if current_user.update_attributes(permitted_params(current_user).user)
      render_success user: current_user.serializer,
                     member: current_user.serializer
    else
      render_failure({reason: current_user.errors.full_messages.to_sentence}, 422)
    end
  end

  def secure_update
    if @member.update_attributes(permitted_params(@member).secure_user)
      render_success user: @member.serializer,
                     member: @member.serializer
    else
      render_failure({reason: @member.errors.full_messages.to_sentence}, 422)
    end
  end

  private

  def load_members!
    authorize! :index, Member
    search_params = params.permit(:pha_id, :is_premium)
    if search_params.has_key? :is_premium
      search_params[:is_premium] = search_params[:is_premium] == 'true'
    end

    @members = Member.signed_up.where(search_params).order('last_contact_at DESC')
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
    @member = Member.find(params[:id])
    authorize! :manage, @member
  end

  def convert_legacy_parameters!
    if update_email_path?
      params[:user] = {current_password: params[:password], email: params[:email]}
    elsif update_password_path?
      params[:user] = {current_password: params[:current_password], password: params[:password]}
    end
  end

  def update_email_path?
    request.env['PATH_INFO'].include?('update_email')
  end

  def update_password_path?
    request.env['PATH_INFO'].include?('update_password')
  end

  def load_member_from_login!
    @member = login(current_user.email, params.require(:user).require(:current_password))
    render_failure({reason: 'Current password is invalid'}, 422) and return unless @member
    authorize! :manage, @member
  end

  def load_waitlist_entry!
    return unless Metadata.use_invite_flow?
    return if user_params[:token] == 'better120' && !Rails.env.production?
    @waitlist_entry = WaitlistEntry.invited.find_by_token(user_params[:token])
    render_failure({reason: 'Invalid invitation code', user_message: 'Invalid invitation code'}, 422) and return unless @waitlist_entry
    @waitlist_entry.state_event = :claim
  end

  def convert_parameters!
    user_params[:avatar] = decode_b64_image(user_params[:avatar]) if user_params[:avatar]
    %w(user_information address insurance_policy provider emergency_contact).each do |key|
      user_params["#{key}_attributes".to_sym] = user_params[key.to_sym] if user_params[key.to_sym]
    end
    user_params[:waitlist_entry] = @waitlist_entry if @waitlist_entry
    user_params[:user_agreements_attributes] = user_agreements_attributes if user_params[:tos_checked] || user_params[:agreement_id]
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

  def user_params
    params.fetch(:user){params.require(:member)}
  end

  def serializer_options
    {}.tap do |options|
      options.merge!(include_nested_information: true, include_roles: true) if current_user.care_provider?
    end
  end
end
