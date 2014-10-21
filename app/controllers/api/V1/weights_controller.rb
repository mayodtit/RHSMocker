class Api::V1::WeightsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_weights!
  before_filter :load_weight!, only: %i(show update destroy)

  def index
    index_resource @weights.serializer
  end

  def show
    show_resource @weight.serializer
  end

  def create
    params = permitted_params.weight
    params[:creator] = current_user
    create_resource @weights, params
  end

  def update
    update_resource @weight, permitted_params.weight
  end

  def destroy
    destroy_resource @weight
  end

  private

  def load_weights!
    @weights = @user.weights
  end

  def load_weight!
    @weight = @weights.find(params[:id])
    authorize! :manage, @weight
  end
end
