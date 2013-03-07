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

  def update_password
    user = login(current_user.email, params[:current_password])
    return render_failure( {reason:"Invalid current password"} ) unless user
    return render_failure( {reason:"Empty new password"} ) unless params[:password].present?

    if user.update_attributes(:password => params[:password])
      render_success( {user:user} )
    else
      render_failure( {reason:user.errors.full_messages} )
    end
  end

  def read
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.markRead(Content.find(params[:contentId]))
        format.html { redirect_to @user, notice: 'User reading was successfully updated.' }
        format.json { head :no_content}
      else
        format.html { redirect_to @user, notice: 'User reading was not updated.'}
        #decided to be silent on errors, including if the content was already read
        format.json { head :no_content }
      end
    end
  end

  def dismiss
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.markDismissed(Content.find(params[:contentId]))
        format.html { redirect_to @user, notice: 'User reading was successfully dismissed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @user, notice: 'User reading was not dismissed.'}
        #decided to be silent on errors, including if the content was already read
        format.json { head :no_content }
      end
    end
  end

  def later
   @user = User.find(params[:id])

    respond_to do |format|
      if @user.markReadLater(Content.find(params[:contentId]))
        format.html { redirect_to @user, notice: 'Content was set to read later.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @user, notice: 'User reading was not set to read later.'}
         #decided to be silent on errors, including if the content was already read
        format.json { head :no_content }
      end
    end
  end

  # GET /users/1
  # GET /users/1.json
  def showReadingList
    @user = User.includes(:contents).find(params[:id])

    respond_to do |format|
      format.html { redirect_to @user }
      format.json { render json: @user.readContent}
    end
  end

  def resetReadingList
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.resetReadingList
        format.html { redirect_to @user, notice: 'User readings were reset.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @user, notice: 'User readings were not reset.'}
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def updateWeight
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.updateWeight(params[:weight])
        format.html { redirect_to @user, notice: 'User weight was set.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @user, notice: 'User weight was not set.'}
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def addLocation
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.addLocation(params[:lat], params[:long])
        format.html { redirect_to @user, notice: 'User location was set.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @user, notice: 'User location was not set.'}
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

   def keywords
    @user = User.find(params[:id])

    respond_to do |format|
      format.html { render html: @user.keywords}
      format.json { render json: @user.keywords}
    end
  end



end
