class Api::V1::UsersController < Api::V1::ABaseController
  skip_before_filter :authentication_check, only: :create
  before_filter :load_users!, only: :index
  before_filter :load_user!, only: [:show, :update]
  before_filter :convert_legacy_parameters!, only: :secure_update
  before_filter :load_user_from_login!, only: :secure_update
  before_filter :convert_parameters!, only: [:create, :update]

  def index
    index_resource @users
  end

  def show
    show_resource @user.as_json(only: [:first_name, :last_name, :email], methods: [:full_name, :admin?, :nurse?])
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
    @user = params[:id] ? User.find(params[:id]) : current_user
    authorize! :manage, @user
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

  def load_user_from_login!
    @user = login(current_user.email, params.require(:user).require(:current_password))
    render_failure(reason: 'Invalid current password') and return unless @user
    authorize! :manage, @user
  end

  def convert_parameters!
    params[:user][:agreement_params] = agreement_params if params[:user][:tos_checked]
    params[:user][:avatar] = decode_b64_image(params[:user][:avatar]) if params[:user][:avatar].present?
  end

  def agreement_params
    {
      ids: Agreement.active.pluck(:id),
      ip_address: request.remote_ip,
      user_agent: request.env['HTTP_USER_AGENT']
    }
  end

  def create_params
    user_params.merge!(params.require(:user).permit(:email, :password))
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
                                 :agreement_params => [:user_agent, :ip_address, :ids => []])
  end

  def client_data_params
    params.require(:user)[:client_data]
  end

  def secure_params
    params.require(:user).permit(:email, :password)
  end
end
