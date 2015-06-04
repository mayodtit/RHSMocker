class Api::V1::ServiceTemplatesController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_service_templates!
  before_filter :load_service_template!, only: :show
  before_filter :prevent_update_service_template, only: :update

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

    if service_template_attributes[:state_event] == 'publish'
      @service_template.publish!
    end

    @new_service_template = ServiceTemplate.create_service_template_deep_copy!(service_template_attributes.merge(unique_id: @service_template.unique_id))

    if @new_service_template.update_attributes(service_template_attributes)
      render_success(service_template: @new_service_template.serializer)
    else
      render_failure({reason: @new_service_template.errors.full_messages.to_sentence}, 422)
    end
  end

  private

  def prevent_update_service_template
    if @service_template.published? || @service_template.retired?
      render_failure({reason: 'ServiceTemplate is published or retired. You cannot update it.'}, 422)
    end
  end

  def load_service_template!
    @service_template = ServiceTemplate.find params[:id]
  end

  def load_service_templates!
    @service_templates = ServiceTemplate.where(params.permit(:service_type_id))
  end

  def service_template_attributes
    params.require(:service_template).permit(:name, :title, :description, :service_type_id, :time_estimate, :state_event)
  end
end
