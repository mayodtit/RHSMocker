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

  def update
    if @user_image.update_attributes(user_image_attributes)
      @user_image = UserImage.find(@user_image.id) # force reload of CarrierWave image url
      render_success(user_image: @user_image.serializer)
    else
      render_failure({user_image: @user_image.errors.full_messages.to_sentence}, 422)
    end
  end

  def create
    create_resource @user_images, user_image_attributes
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

  def user_image_attributes
    request.body.rewind
    @request_body = JSON.parse(request.body.read, {:symbolize_names => true})
    permitted_params.user_image.tap do |attributes|
      attributes[:image] = decode_b64_image(@request_body[:user_image][:image])
      attributes[:client_guid] = @request_body[:client_guid]
    end
  end
end
