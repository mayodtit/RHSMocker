class Api::V1::ServiceTemplatesController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_service_templates!
  before_filter :load_service_template!, only: %i(show update)
  before_filter :prevent_update_service_template, only: :update

  def index
    authorize! :read, ServiceTemplate
    index_resource @service_templates.serializer
  end

  def create
    authorize! :create, ServiceTemplate

    if unique_id = params[:service_template].try(:[], :unique_id)
      @current_service_template = ServiceTemplate.where(unique_id: unique_id).order('version DESC').first!
      @new_service_template = @current_service_template.create_deep_copy!
    else
      create_resource @service_templates, permitted_params.service_template_attributes
    end
  end

  def show
    authorize! :read, @service_template
    show_resource @service_template.serializer
  end

  def update
    authorize! :update, @service_template

    if params[:state_event] == 'publish'
      @service_template.publish!
    end

    update_resource @service_template, permitted_params.service_template_attributes
  end

  def destroy
    authorize! :destroy, @service_template

    if @service_template.unpublished?
      destroy_resource @service_template
    end
  end

  private

  def load_service_template!
    @service_template = ServiceTemplate.find params[:id]
  end

  def load_service_templates!
    authorize! :index, ServiceTemplate

    @service_templates = ServiceTemplate.where(state: params[:state]).order('service_templates.created_at DESC')
    @service_templates = @service_templates.title_search(params[:title]) if params[:title]
  end

  def prevent_update_service_template
    if @service_template.published? || @service_template.retired?
      render_failure({reason: 'ServiceTemplate is published or retired. You cannot update it.'}, 422)
    end
  end
end
