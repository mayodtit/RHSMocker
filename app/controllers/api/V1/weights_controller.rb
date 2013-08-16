class Api::V1::WeightsController < Api::V1::ABaseController
  include ActiveModel::MassAssignmentSecurity
  attr_accessible :amount, :bmi, :taken_at

  before_filter :load_user!
  before_filter :load_weight!, only: :destroy

  def index
    index_resource(@user.weights)
  end

  def create
    create_resource(@user.weights, sanitize_for_mass_assignment(params[:weight]))
  end

  def destroy
    destroy_resource(@weight)
  end

  private

  def load_weight!
    @weight = @user.weights.find(params[:id])
    authorize! :manage, @weight
  end
end
