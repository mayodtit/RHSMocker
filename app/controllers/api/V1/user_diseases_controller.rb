class Api::V1::UserDiseasesController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_user_disease!, only: [:show, :update, :destroy]

  def index
    render_success(user_diseases: @user.user_diseases)
  end

  def show
    render_success(user_disease: @user_disease)
  end

  def create
    @user_disease = @user.user_diseases.create(params[:user_disease])
    if @user_disease.errors.empty?
      render_success(user_disease: @user_disease)
    else
      render_failure({reason: @user_disease.errors.full_messages.to_sentence}, 422)
    end
  end

  def update
    if @user_disease.update_attributes(params[:user_disease])
      render_success(user_disease: @user_disease)
    else
      render_failure({reason: @user_disease.errors.full_messages.to_sentence}, 422)
    end
  end

  def destroy
    if @user_disease.destroy
      render_success
    else
      render_failure({reason: @user_disease.errors.full_messages.to_sentence}, 422)
    end
  end

  private

  def load_user!
    @user = params[:user_id] ? User.find(params[:user_id]) : current_user
    authorize! :manage, @user
  end

  def load_user_disease!
    @user_disease = @user.user_diseases.find(params[:id])
    authorize! :manage, @user_disease
  end
end
