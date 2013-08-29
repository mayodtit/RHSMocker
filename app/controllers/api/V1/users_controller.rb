class Api::V1::UsersController < Api::V1::ABaseController
  include ActiveModel::MassAssignmentSecurity
  attr_accessible :first_name, :last_name, :image_url, :gender, :height, :birth_date, :email, :phone,
                  :generic_call_time, :password, :password_confirmation, :feature_bucket, :blood_type,
                  :holds_phone_in, :diet_id, :ethnic_group_id, :deceased, :date_of_death, :npi_number,
                  :expertise, :city, :state, :units

  skip_before_filter :authentication_check, :only =>:create
  before_filter :load_user!, :only => :update

  def index
    begin
      @users = search_service.query(params)
      render_success(users: @users)
    rescue => e
      render_failure({reason: e.message}, 502)
    end
  end

  def create
    params[:install_id] ||= ('RHS-' + SecureRandom.base64)
    @user = Member.where(:install_id => params[:install_id]).first_or_initialize
    if @user.email.present?
      render_failure({reason:"Registration is already complete",
                      user_message: 'User with this email already exists'}, 409)
      return
    end
    if @user.update_attributes(params[:user])
      auto_login(@user)
      @user.login
      UserMailer.welcome_email(@user).deliver unless @user.email.blank?
      render_success(auth_token: @user.auth_token, user: @user)
    else
      render_failure({reason: @user.errors.full_messages.to_sentence,
                      user_message: @user.errors.full_messages.to_sentence}, 422)
    end
  end

  def update
    update_resource(@user, sanitized_params)
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

  def keywords
    render_success keywords: Member.find(params[:id]).keywords.map{|mv| mv[0].title }[0,7]
  end

  def invite
    @user = User.find(params[:id])
    @member = @user.member || Member.create_from_user!(@user)
    current_user.invitations.create(invited_member: @member) # fail silently, always return success
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

  def sanitized_params
    params[:user].delete(:email) if @user == current_user
    params[:user].delete(:password)
    sanitize_for_mass_assignment(params[:user])
  end
end
