class Api::V1::SessionsController < Api::V1::ABaseController
  skip_before_filter :authentication_check, only: :create

  def create
    @user = login(email, password)
    if @user
      @session = @user.sessions.create
      if @user.pha
        render_success(user: @user.serializer(include_roles: true),
                       pha: @user.pha.serializer,
                       auth_token: @session.auth_token)
      else
        render_success(user: @user.serializer(include_roles: true),
                       auth_token: @session.auth_token)
      end
      Analytics.log_user_login(@user.google_analytics_uuid)
    else
      render_failure({reason:"Incorrect credentials", user_message: 'Email or password is invalid'}, 401)
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

  def email
    params[:user].try(:[], :email) || params[:email]
  end

  def password
    params[:user].try(:[], :password) || params[:password]
  end
end
