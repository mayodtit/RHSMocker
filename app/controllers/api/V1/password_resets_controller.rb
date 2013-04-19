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

  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token)
  end
 
  def update
    @token = params[:token]
    @user = User.load_from_reset_password_token(@token)

    if @user.present?
      @user.password_confirmation = params[:user][:password_confirmation]

      # clears the temporary token and updates the password
      if @user.change_password!(params[:user][:password])
        render :update
      else
        render :edit
      end
    end
  end

end
