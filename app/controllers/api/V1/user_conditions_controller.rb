class Api::V1::UserConditionsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_user_condition!, only: [:show, :update, :destroy]

  def index
    index_resource(@user.user_conditions)
  end

  def show
    show_resource(@user_condition)
  end

  def create
    create_resource(@user.user_conditions, params[:user_condition])
  end

  def update
    update_resource(@user_condition, params[:user_condition])
  end

  def destroy
    destroy_resource(@user_condition)
  end

  private

  def load_user_condition!
    @user_condition = @user.user_conditions.find(params[:id])
    authorize! :manage, @user_condition
  end
end
