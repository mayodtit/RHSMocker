class Api::V1::HeightsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_heights!
  before_filter :load_height!, only: %i(show update destroy)

  def index
    index_resource @heights.serializer
  end

  def show
    show_resource @height.serializer
  end

  def create
    create_resource @heights, create_attributes
  end

  def update
    update_resource @height, permitted_params.height
  end

  def destroy
    destroy_resource @height
  end

  private

  def load_heights!
    @heights = @user.heights
  end

  def load_height!
    @height = @heights.find(params[:id])
  end

  def create_attributes
    permitted_params.height.tap do |attributes|
      attributes[:creator] = current_user
    end
  end
end
