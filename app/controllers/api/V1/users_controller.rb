class Api::V1::UsersController < Api::V1::ABaseController
  include ActiveModel::MassAssignmentSecurity
  attr_accessible :first_name, :last_name, :image_url, :gender, :height, :birth_date, :email, :phone,
                  :generic_call_time, :password, :password_confirmation, :feature_bucket, :blood_type,
                  :holds_phone_in, :diet_id, :ethnic_group_id, :deceased, :date_of_death, :npi_number,
                  :expertise, :city, :state

  skip_before_filter :authentication_check, :only =>:create

  def index
    if params[:only] == 'internal'
      if params[:q]
        @users = Member.search do
          fulltext params[:q]
          with :role_name, params[:role_name] if params[:role_name]
        end
      else
        @users = params[:role_name] ? (Role.find_by_name(params[:role_name]).try(:users) || []) : Member.all
      end
    else
      begin
        @users = search_service.query(params)
      rescue => e
        render_failure({reason: e.message}, 502) and return
      end
    end
    render_success(users: @users)
  end

  def create
    # TODO: refactor into the model
    if params[:user].present? && params[:user][:install_id].present?
      user = Member.find_by_install_id(params[:user][:install_id])
    end

    if user.present?
      if user.email.blank? && params[:user][:password].present? && params[:user][:email].present?
        user.update_attributes params[:user]
      else
        return render_failure( {reason:"Registration is already complete"}, 409 )
      end
    else
      user = Member.new(params[:user])
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
    if user.update_attributes(sanitize_for_mass_assignment(params[:user]))
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
    render_success keywords: Member.find(params[:id]).keywords.map{|mv| mv[0].title }[0,7]
  end

  def add_feedback
    feedback = Feedback.create({:note=>params['note'], :user=>current_user})
    if feedback.errors.empty?
      render_success( {feedback:feedback})
    else
      render_failure( {reason:feedback.errors.full_messages.to_sentence}, 422 )
    end
  end

  def invite
    @user = User.find(params[:id])
    @member = @user.member || Member.create_from_user!(@user)
    current_user.invitations.create!(invited_member: @member)
    render_success
  end

  private

  def search_service
    @search_service ||= Search::Service.new
  end
end
