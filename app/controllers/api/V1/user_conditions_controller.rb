class Api::V1::UserConditionsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_user_condition!, only: [:show, :update, :destroy]

  def index
    index_resource(@user.user_conditions.serializer, name: :user_diseases) and return if disease_path?
    index_resource(@user.user_conditions.serializer)
  end

  def show
    show_resource(@user_condition.serializer, name: :user_disease) and return if disease_path?
    show_resource(@user_condition.serializer)
  end

  def create
    #deprecated
    create_resource(@user.user_conditions, params[:user_disease], name: :user_disease) and return if disease_path?

    #new api requires condition
    if params[:condition]
      condition = Condition.where(description_id: params[:condition][:description_id])
      condition[0] = Condition.create(params[:condition]) if condition.none?
    end

    params[:user_condition] = {condition_id: condition[0][:id]} unless params[:user_condition]

    #common for deprecated and new api
    params[:user_condition][:actor_id] = current_user.id
    create_resource(@user.user_conditions, params[:user_condition])
  end

  def update
    update_resource(@user_condition, params[:user_disease], name: :user_disease) and return if disease_path?
    update_resource(@user_condition, params[:user_condition])
  end

  def destroy
    @user_condition.actor_id = current_user.id
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
