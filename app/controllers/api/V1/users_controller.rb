class Api::V1::UsersController < Api::V1::ABaseController
  skip_before_filter :authentication_check, :only =>:create

  def create
    # TODO: refactor into the model
    if params[:user].present? && params[:user][:install_id].present?
      user = User.find_by_install_id(params[:user][:install_id])
    end

    if user.present? && user.email.blank?
      password = params[:user][:password]
      params[:user].delete :password
      user.update_attributes params[:user]
      user.password = password
    else
      user = User.new(params[:user])
    end

    if user.save
      auto_login(user)
      user.login
      render_success( {auth_token:user.auth_token, user:user} )
    else
      render_failure( {reason:user.errors.full_messages.to_sentences} )
    end
  end

  def update
    if params[:id].present?
      if current_user.allowed_to_edit_user? params[:id].to_i
        user = User.find(params[:id])
      else
        return render_failure({reason:"Not authorized to edit this user"})
      end
    else
      user = current_user
    end

    if user.update_attributes(params[:user])
      render_success({user:user})
    else
      render_failure({reason:user.errors.full_messages.to_sentence}, 422) 
    end
  end


  def keywords
    render_success current_user.keywords
  end
end
