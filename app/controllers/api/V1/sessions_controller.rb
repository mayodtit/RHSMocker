class Api::V1::SessionsController < Api::V1::ABaseController
  skip_before_filter :authentication_check, :only =>:create

  def create
    if params[:email] && params[:password]
      user = login(params[:email], params[:password])
      return render_failure({reason:"Incorrect credentials", user_message: 'Invalid email and/or password'}, 401) unless user
      if params[:auth_token] && params[:auth_token]!=user.auth_token
        #merge user_readings
        original_user = Member.find_by_auth_token params[:auth_token]
        user.merge(original_user) if original_user
      end
    elsif params[:install_id]
      user = Member.find_by_install_id(params[:install_id])
      if user.present?
        if user.email.present?
          user = nil
        else
          auto_login(user)
        end
      end
    end

    if user.blank?
      render_failure({reason:"Incorrect credentials", user_message: 'Invalid email and/or password'}, 401) unless performed?
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
