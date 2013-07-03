class Api::V1::UserAllergiesController < Api::V1::ABaseController
  include ActiveModel::MassAssignmentSecurity
  attr_accessible :user_id, :allergy_id

  before_filter :load_user!
  before_filter :load_user_allergy!, only: [:show, :update, :destroy]

  def index
    index_resource(@user.user_allergies)
  end

  def show
    show_resource(@user_allergy)
  end

  def create
    create_resource(@user.user_allergies, sanitize_for_mass_assignment(params[:user_allergy]))
  end

  def destroy
    destroy_resource(@user_allergy)
  end

  private

  def load_user!
    @user = params[:user_id] ? User.find(params[:user_id]) : current_user
    authorize! :manage, @user
  end

  def load_user_allergy!
    @user_allergy = @user.user_allergies.find(params[:id])
    authorize! :manage, @user_allergy
  end
end
