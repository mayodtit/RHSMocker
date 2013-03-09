class Api::V1::SessionsController < Api::V1::ABaseController
  skip_before_filter :authentication_check, :only =>:create

  def create
    if params[:email] && params[:password]
      user = login(params[:email], params[:password])
    elsif params[:install_id]
      user = User.find_by_install_id(params[:install_id])
      if user.present?
        if user.email.present?
          user = nil
        else
          auto_login(user)
        end
      end
    end

    if user.blank?
      render_failure({reason:"Incorrect credentials"}, 401) unless performed?
    else
      user.login
      render_success(auth_token:user.auth_token, user:user)
    end
  end

  def destroy
    current_user.auth_token = nil
    current_user.save
    logout
    render_success
  end
end
