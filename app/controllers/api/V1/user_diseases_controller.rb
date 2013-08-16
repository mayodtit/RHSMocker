class Api::V1::UserDiseasesController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_user_disease!, only: [:show, :update, :destroy]

  def index
    index_resource(@user.user_diseases)
  end

  def show
    show_resource(@user_disease)
  end

  def create
    create_resource(@user.user_diseases, params[:user_disease])
  end

  def update
    update_resource(@user_disease, params[:user_disease])
  end

  def destroy
    destroy_resource(@user_disease)
  end

  private

  def load_user_disease!
    @user_disease = @user.user_diseases.find(params[:id])
    authorize! :manage, @user_disease
  end
end
