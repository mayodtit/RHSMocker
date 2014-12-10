class Api::V1::ServiceTemplatesController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_service_template!, only: :show
  before_filter :load_service_templates!, only: :index

  def index
    authorize! :read, ServiceTemplate
    index_resource @service_templates.serializer
  end

  def show
    authorize! :read, @service_template
    show_resource @service_template.serializer
  end

  private

  def load_service_template!
    @service_template = ServiceTemplate.find params[:id]
  end

  def load_service_templates!
    search_params = params.permit(:service_type_id)
    @service_templates = ServiceTemplate.where(search_params)
  end
end
