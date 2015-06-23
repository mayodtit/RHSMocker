class Api::V1::SessionsController < Api::V1::ABaseController
  skip_before_filter :authentication_check, only: :create
  before_filter :authenticate_user, only: :create
  before_filter :load_sessions!, only: :create

  def create
    @session = @sessions.create
    if @session.errors.empty?
      render_success(user: @user.serializer(include_roles: true),
                     pha: @user.pha.try(:serializer),
                     auth_token: @session.auth_token)
       Analytics.log_user_login(@user.google_analytics_uuid)
     else
       render_failure({reason: @session.errors.full_messages.to_sentence}, 422)
     end
  end

  def destroy
    current_session.destroy
    uuid = current_user.google_analytics_uuid
    logout
    render_success
    Analytics.log_user_logout(uuid)
  end

  private

  def authenticate_user
    @user = login(email, password)
    render_failure({reason:"Incorrect credentials", user_message: 'Email or password is invalid'}, 401) unless @user
  end

  def load_sessions!
    if params[:care_portal]
      @sessions = @user.care_portal_sessions
    else
      @sessions = @user.sessions
    end
  end

  def email
    params[:user].try(:[], :email) || params[:email]
  end

  def password
    params[:user].try(:[], :password) || params[:password]
  end
end
