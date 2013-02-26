class Api::V1::UsersController < Api::V1::ABaseController
   skip_before_filter :authentication_check, :only =>:create
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.includes(:contents).find(params[:id])

    respond_to do |format|
      format.html #{ render html: @user.readContent }
      format.json { render json: @user}
    end
  end


  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  def create
    # TODO: refactor into the model
    if params[:user].present? && params[:user][:install_id].present?
      user = User.find_by_install_id(params[:user][:install_id])
    end

    if user.present?
      user.update_attributes params[:user]
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

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  # def destroy
  #   @user = User.find(params[:id])
  #   @user.destroy

  #   respond_to do |format|
  #     format.html { redirect_to users_url }
  #     format.json { head :no_content }
  #   end
  # end

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
