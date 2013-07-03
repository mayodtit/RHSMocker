class Api::V1::UserTreatmentsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_user_disease_treatment!, only: [:show, :update, :destroy]

  def index
    index_resource(@user.user_disease_treatments)
  end

  def show
    show_resource(@user_disease_treatment)
  end

  def create
    create_resource(@user.user_disease_treatments, params[:user_disease_treatment])
  end

  def update
    update_resource(@user_disease_treatment, params[:user_disease_treatment])
  end

  def destroy
    destroy_resource(@user_disease_treatment)
  end

  private

  def load_user!
    @user = params[:user_id] ? User.find(params[:user_id]) : current_user
    authorize! :manage, @user
  end

  def load_user_disease_treatment!
    @user_disease_treatment = @user.user_disease_treatments.find(params[:id])
    authorize! :manage, @user_disease_treatment
  end
end
