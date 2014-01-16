class Api::V1::UsersController < Api::V1::ABaseController
  skip_before_filter :authentication_check, only: :create
  before_filter :load_users!, only: :index
  before_filter :load_user!, only: [:show, :update]
  before_filter :convert_legacy_parameters!, only: :secure_update
  before_filter :load_user_from_login!, only: :secure_update
  before_filter :convert_parameters!, only: [:create, :update, :update_current]
  before_filter :load_waitlist_entry!, only: :create

  def index
    index_resource @users
  end

  def show
    show_resource @user
  end

  def current
    show_resource current_user
  end

  def create
    @user = Member.create(create_params)
    if @user.errors.empty?
      render_success(user: @user, auth_token: @user.auth_token)
    else
      render_failure({reason: @user.errors.full_messages.to_sentence,
                      user_message: @user.errors.full_messages.to_sentence}, 422)
    end
  end

  def update
    update_resource @user, user_params
  end

  def secure_update
    update_resource @user, secure_params
  end

  def update_current
    update_resource current_user, user_params
  end

  # Invites a ghost user
  def invite
    @user = User.find(params[:id])
    @member = @user.member || Member.create_from_user!(@user)
    current_user.invitations.create(invited_member: @member) # fail silently, always return success
    render_success
  end

  private

  def load_users!
    begin
      @users = search_service.query(params)
    rescue => e
      render_failure({reason: e.message}, 502)
    end
  end

  def search_service
    @search_service ||= Search::Service.new
  end

  def load_user!
    @user = User.find(params[:id])
    authorize! :manage, @user
  end

  def convert_legacy_parameters!
    if update_email_path?
      params[:user] = {current_password: params[:password], email: params[:email]}
    elsif update_password_path?
      params[:user] = {current_password: params[:current_password], password: params[:password]}
    end
  end

  def load_waitlist_entry!
    return unless Metadata.use_invite_flow?
    return if params[:user][:token] == 'better120' # TODO - remove magic token
    @waitlist_entry = WaitlistEntry.invited.find_by_token(params[:user][:token])
    render_failure({reason: 'Invalid invitation code', user_message: 'Invalid invitation code'}, 422) and return unless @waitlist_entry
    @waitlist_entry.state_event = :claim
  end

  def update_email_path?
    request.env['PATH_INFO'].include?('update_email')
  end

  def update_password_path?
    request.env['PATH_INFO'].include?('update_password')
  end

  def load_user_from_login!
    @user = login(current_user.email, params.require(:user).require(:current_password))
    render_failure(reason: 'Invalid current password') and return unless @user
    authorize! :manage, @user
  end

  def convert_parameters!
    params[:user][:user_agreements_attributes] = user_agreements_attributes if params[:user][:tos_checked]
    params[:user][:avatar] = decode_b64_image(params[:user][:avatar]) if params[:user][:avatar].present?
  end

  def user_agreements_attributes
    return [] unless Agreement.active
    [
      {
        agreement_id: Agreement.active.id,
        ip_address: request.remote_ip,
        user_agent: request.env['HTTP_USER_AGENT']
      }
    ]
  end

  def create_params
    permitted_params = user_params.merge!(params.require(:user).permit(:email, :password))
    permitted_params.merge!(waitlist_entry: @waitlist_entry) if @waitlist_entry
    permitted_params
  end

  def user_params
    permitted_params = common_params
    permitted_params.merge!(params.require(:user).permit(:email)) if current_user != @user
    permitted_params.merge!(client_data: client_data_params) if client_data_params
    permitted_params
  end

  def common_params
    params.require(:user).permit(:first_name, :last_name, :avatar, :gender, :height,
                                 :birth_date, :phone, :blood_type, :holds_phone_in,
                                 :diet_id, :ethnic_group_id, :deceased, :date_of_death,
                                 :npi_number, :expertise, :city, :state, :units,
                                 :nickname).tap do |attributes|
                                   attributes[:user_agreements_attributes] = params[:user][:user_agreements_attributes] if params[:user][:user_agreements_attributes]
                                 end
  end

  def client_data_params
    params.require(:user)[:client_data]
  end

  def secure_params
    params.require(:user).permit(:email, :password)
  end
end
