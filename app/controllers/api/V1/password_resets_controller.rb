class Api::V1::PasswordResetsController < Api::V1::ABaseController
  skip_before_filter :authentication_check

  def create
    user = User.find_by_email(params[:email]) if params[:email].present?
    if user
      user.deliver_reset_password_instructions!  # emails a url with a random token
      render_success
    else
      render_failure( {reason:"User with email '#{params[:email]}' does not exist.  Failed to send password reset instructions."}, 404 )
    end
  end
end
