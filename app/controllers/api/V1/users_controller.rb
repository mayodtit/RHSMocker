class Api::V1::UsersController < Api::V1::ABaseController
  include ActiveModel::MassAssignmentSecurity
  attr_accessible :first_name, :last_name, :avatar, :gender, :height, :birth_date, :email, :phone,
                  :password, :password_confirmation, :blood_type,
                  :holds_phone_in, :diet_id, :ethnic_group_id, :deceased, :date_of_death, :npi_number,
                  :expertise, :city, :state, :units, :agreement_params, :install_id

  skip_before_filter :authentication_check, :only => [:create, :reset_password]
  before_filter :load_user!, :only => :update
  before_filter :upgrade_legacy_users, :only => :create

  def index
    begin
      @users = search_service.query(params)
      render_success(users: @users)
    rescue => e
      render_failure({reason: e.message}, 502)
    end
  end

  def create
    @user = Member.create(create_params)
    if @user.errors.empty?
      render_success(:user => @user, :auth_token => @user.auth_token)
    else
      render_failure({:reason => @user.errors.full_messages.to_sentence,
                      :user_message => @user.errors.full_messages.to_sentence}, 422)
    end
  end

  # TODO - remove this before filter when old clients supporting anonymous user are removed
  def upgrade_legacy_users
    @user = Member.find_by_install_id(params[:user][:install_id])
    return if @user.nil? || @user.email.present?
    if @user.update_attributes(create_params)
      render_success(:user => @user, :auth_token => @user.auth_token)
    else
      render_failure({:reason => @user.errors.full_messages.to_sentence,
                      :user_message => @user.errors.full_messages.to_sentence}, 422)
    end
  end

  def update
    update_resource(@user, update_params)
  end

  def update_password
    @user = login(current_user.email, params[:current_password])
    render_failure(reason: "Invalid current password") and return unless @user
    update_resource(@user, :password => params[:password])
  end

  def update_email
    @user = login(current_user.email, params[:password])
    render_failure(reason: "Invalid current password") and return unless @user
    update_resource(@user, :email => params[:email])
  end

  def invite
    @user = User.find(params[:id])
    @member = @user.member || Member.create_from_user!(@user)
    current_user.invitations.create(invited_member: @member) # fail silently, always return success
    render_success
  end

  def reset_password
    render_failure({reason: 'Email address required'}, 422) and return unless params[:email].present?
    @user = Member.find_by_email!(params[:email])
    @user.deliver_reset_password_instructions!
    render_success
  end

  private

  def load_user!
    @user = params[:id] ? User.find(params[:id]) : current_user
    authorize! :manage, @user
  end

  def search_service
    @search_service ||= Search::Service.new
  end

  def install_id
    params[:user].try(:[], :install_id) || params[:install_id] || ('RHS-' + SecureRandom.base64)
  end

  def create_params
    if params[:user][:tos_checked]
      params[:user][:agreement_params] = {:ids => Agreement.active.pluck(:id), :ip_address => request.remote_ip, :user_agent => request.env['HTTP_USER_AGENT']}
    end
    sanitize_for_mass_assignment(params[:user])
  end

  def update_params
    params[:user].delete(:email) if @user == current_user
    params[:user].delete(:password)
    params[:user].delete(:install_id)
    params[:user][:avatar] = decode_b64_image(params[:user][:avatar]) if params[:user][:avatar].present?
    sanitize_for_mass_assignment(params[:user])
  end
end
