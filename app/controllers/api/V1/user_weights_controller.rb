class Api::V1::UserWeightsController < Api::V1::ABaseController
  include ActiveModel::MassAssignmentSecurity
  attr_accessible :weight, :bmi, :taken_at

  before_filter :load_user!
  before_filter :load_user_weight!, only: :destroy

  def index
    index_resource(@user.user_weights)
  end

  def create
    create_resource(@user.user_weights, sanitize_for_mass_assignment(params[:user_weight]))
  end

  def destroy
    destroy_resource(@user_weight)
  end

  private

  def load_user!
    @user = params[:user_id] ? User.find(params[:user_id]) : current_user
    authorize! :manage, @user
  end

  def load_user_weight!
    @user_weight = @user.user_weights.find(params[:id])
    authorize! :manage, @user_weight
  end
end
