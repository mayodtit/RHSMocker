class Api::V1::UserConditionsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_user_condition!, only: [:show, :update, :destroy]

  def index
    index_resource(@user.user_conditions, name: :user_diseases) and return if disease_path?
    index_resource(@user.user_conditions)
  end

  def show
    show_resource(@user_condition, name: :user_disease) and return if disease_path?
    show_resource(@user_condition)
  end

  def create
    create_resource(@user.user_conditions, params[:user_disease], name: :user_disease) and return if disease_path?
    create_resource(@user.user_conditions, params[:user_condition])
  end

  def update
    update_resource(@user_condition, params[:user_disease], name: :user_disease) and return if disease_path?
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

  def disease_path?
    request.env['PATH_INFO'].include?('disease')
  end
end
