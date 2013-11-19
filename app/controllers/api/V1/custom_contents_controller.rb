class Api::V1::CustomContentsController < Api::V1::ABaseController
  before_filter :authorize_user!
  before_filter :load_custom_content!, only: [:show, :update]

  def index
    index_resource CustomContent.all
  end

  def show
    show_resource @custom_content
  end

  def create
    create_resource CustomContent, custom_content_params
  end

  def update
    update_resource @custom_content, custom_content_params
  end

  private

  def authorize_user!
    authorize! :manage, CustomContent
  end

  def load_custom_content!
    @custom_content = CustomContent.find params[:id]
  end

  def custom_content_params
    params.require(:custom_content).permit(:title, :raw_body, :content_type, :abstract)
  end
end
