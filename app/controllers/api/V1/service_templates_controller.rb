class Api::V1::ServiceTemplatesController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_service_templates!
  before_filter :load_service_template!, only: :show

  def index
    authorize! :read, ServiceTemplate
    index_resource @service_templates.serializer
  end

  def create
    authorize! :create, ServiceTemplate
    create_resource @service_templates, permitted_params.service_template
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
    @service_templates = ServiceTemplate.where(params.permit(:service_type_id))
  end

end
