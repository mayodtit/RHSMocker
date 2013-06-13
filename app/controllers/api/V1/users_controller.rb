class Api::V1::UsersController < Api::V1::ABaseController
  skip_before_filter :authentication_check, :only =>:create

  def index
    if params[:q]
      @users = User.search do
        fulltext params[:q]
        with :role_name, params[:role_name] if params[:role_name]
      end
    else
      @users = params[:role_name] ? User.by_role(Role.find_by_name(params[:role_name])) : User.all
    end
    render_success(users: @users)
  end

  def create
    # TODO: refactor into the model
    if params[:user].present? && params[:user][:install_id].present?
      user = User.find_by_install_id(params[:user][:install_id])
    end

    if user.present?
      if user.email.blank? && params[:user][:password].present? && params[:user][:email].present?
        user.update_attributes params[:user]
      else
        return render_failure( {reason:"Registration is already complete"}, 409 )
      end
    else
      user = User.new(params[:user])
    end

    if user.save
      auto_login(user)
      user.login
      UserMailer.welcome_email(user).deliver unless user.email.blank?
      render_success( {auth_token:user.auth_token, user:user} )
    else
      render_failure( {reason:user.errors.full_messages.to_sentence}, 422 )
    end
  end

  def update
    params[:user].delete :password
    params[:user].delete :email

    if params[:id].present?
      if current_user.allowed_to_edit_user? params[:id].to_i
        user = User.find_by_id params[:id]
      else
        return render_failure({reason:"Not authorized to edit this user"})
      end
    else
      user = current_user
    end
    return render_failure({reason:"User not found"}, 404) unless user
    if user.update_attributes(params[:user])
      render_success({user:user})
    else
      render_failure({reason:user.errors.full_messages.to_sentence}, 422)
    end
  end

  def update_password
    user = login(current_user.email, params[:current_password])
    return render_failure( {reason:"Invalid current password"} ) unless user
    return render_failure( {reason:"Empty new password"}, 412 ) unless params[:password].present?
    if user.update_attributes(:password => params[:password])
      render_success( {user:user} )
    else
      render_failure( {reason:user.errors.full_messages.to_sentence}, 422 )
    end
  end

  def update_email
    user = login(current_user.email, params[:password])
    return render_failure( {reason:"Invalid password"} ) unless user
    if user.update_attributes(:email => params[:email])
      render_success( {user:user} )
    else
      render_failure( {reason:user.errors.full_messages.to_sentence}, 422 )
    end
  end

  def keywords
    render_success keywords:current_user.keywords.map{|mv| mv[0].title }[0,7]
  end

  def add_feedback
    feedback = Feedback.create({:note=>params['note'], :user=>current_user})
    if feedback.errors.empty?
      render_success( {feedback:feedback})
    else
      render_failure( {reason:feedback.errors.full_messages.to_sentence}, 422 )
    end
  end

end
