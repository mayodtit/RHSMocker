class Api::V1::ContentReferencesController < Api::V1::ABaseController
  before_filter :authorize_user!
  before_filter :load_content!

  def index
    index_resource @content.content_references.serializer
  end

  def create
    create_resource @content.content_references, content_reference_params
  end

  def destroy
    destroy_resource @content.content_references.find(params[:id])
  end

  private

  def authorize_user!
    authorize! :manage, ContentReference
  end

  def load_content!
    @content = Content.find(params[:content_id])
  end

  def content_reference_params
    params.require(:content_reference).permit(:referee_id)
  end
end
