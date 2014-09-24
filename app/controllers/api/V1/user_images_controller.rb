class Api::V1::UserImagesController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_user_images!
  before_filter :load_user_image!, only: %i(show update destroy)

  def index
    index_resource @user_images.serializer
  end

  def show
    show_resource @user_image.serializer
  end

  def create
    create_resource @user_images, permitted_params.user_image
  end

  def update
    update_resource @user_image, permitted_params.user_image
  end

  def destroy
    destroy_resource @user_image
  end

  private

  def load_user_images!
    @user_images = @user.user_images
  end

  def load_user_image!
    @user_image = @user_images.find(params[:id])
    authorize! :manage, @user_image
  end
end