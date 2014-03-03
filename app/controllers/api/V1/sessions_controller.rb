class Api::V1::SessionsController < Api::V1::ABaseController
  skip_before_filter :authentication_check, :only =>:create

  def create
    @user = login(email_param, password_param)
    if @user.try_method(:login)
      render_success(auth_token: @user.auth_token, user: @user.serializer(include_roles: true))
      Analytics.log_user_login(@user.google_analytics_uuid)
    else
      render_failure({reason:"Incorrect credentials", user_message: 'Invalid email address or password.'}, 401)
    end
  end

  def destroy
    uuid = current_user.google_analytics_uuid
    current_user.logout
    logout
    render_success
    Analytics.log_user_logout(uuid)
  end

  private

  def email_param
    params[:user].try(:[], :email) || params[:email]
  end

  def password_param
    params[:user].try(:[], :password) || params[:password]
  end
end
