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

  def update
    authorize! :update, @service_template

    update_params = service_template_attributes

    if @service_template.update_attributes(update_params)
      render_success(service_template: @service_template.serializer)
    else
      render_failure({reason: @service_template.errors.full_messages.to_sentence}, 422)
    end
  end

  private

  def load_service_template!
    @service_template = ServiceTemplate.find params[:id]
  end

  def load_service_templates!
    @service_templates = ServiceTemplate.where(params.permit(:service_type_id))
  end

  def service_template_attributes
    params.require(:service_template).permit(:name, :title, :description, :service_type_id, :time_estimate, :state)
  end

end
