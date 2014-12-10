class Api::V1::ServiceTemplatesController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_service_template!
  before_filter :load_service_templates!


  def show
    show_resource @service_template.serializer
  end

  def index
    show_resource @service_templates.serializer
  end

  def generate
    @service_template.create_service! params
  end

  private

  def load_service_template!
    @service_template = @service_templates.find params[:id]
    authorize! :manage, @service_template
  end

  def load_service_templates!
    @service_templates = ServiceTemplate.all
    authorize! :manage, ServiceTemplate
  end
end
