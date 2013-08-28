class Api::V1::SessionsController < Api::V1::ABaseController
  skip_before_filter :authentication_check, :only =>:create

  def create
    @user = login(params[:email], params[:password])
    if @user.try_method(:login)
      render_success(auth_token: @user.auth_token, user: @user)
    else
      render_failure({reason:"Incorrect credentials", user_message: 'Invalid email and/or password'}, 401)
    end
  end

  def destroy
    current_user.logout
    logout
    render_success
  end
end
