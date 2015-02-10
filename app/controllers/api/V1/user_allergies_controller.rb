class Api::V1::UserAllergiesController < Api::V1::ABaseController
  include ActiveModel::MassAssignmentSecurity
  attr_accessible :user_id, :allergy_id, :actor_id

  before_filter :load_user!
  before_filter :load_user_allergy!, only: [:show, :destroy]

  def index
    index_resource(@user.user_allergies.serializer)
  end

  def show
    show_resource(@user_allergy.serializer)
  end

  def create
    params[:user_allergy][:actor_id] = current_user.id
    create_resource(@user.user_allergies, sanitize_for_mass_assignment(params[:user_allergy]))
  end

  def destroy
    @user_allergy.actor_id = current_user.id
    destroy_resource(@user_allergy)
  end

  private

  def load_user_allergy!
    @user_allergy = @user.user_allergies.find(params[:id])
    authorize! :manage, @user_allergy
  end
end