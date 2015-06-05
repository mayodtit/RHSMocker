class Api::V1::ServiceTemplatesController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_service_templates!
  before_filter :load_service_template!, only: %w(show update)
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

    if @service_template.unpublished?
      update_resource @service_template, permitted_params.service_template
    else
      @new_service_template = ServiceTemplate.create!(@service_template.attributes.except(:id, :version, :created_at, :updated_at, :state_event))
      @new_service_template.task_templates.each do |tt|
        @new_task_template = TaskTemplate.create!(tt.new_task_template_attributes.merge(:service_template, @new_service_template))
        @new_modal_template = ModalTemplate.create!(tt.modal_template) if @new_task_template.modal_template_id
        tt.update_attributes!(:modal_template_id, @new_modal_template.id) if @new_task_template.modal_template_id
      end

      if @new_service_template.errors.empty?
        render_success(service_template: @new_service_template.serializer)
      else
        render_failure({reason: @new_service_template.errors.full_messages.to_sentence}, 422)
      end
    end
  end

  def destroy
    authorize! :destroy, @service_template

    if @service_template.unpublished?
      destroy_resource @service_template
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

  def new_task_template_attributes
    params.require(:task_template).permit(:name, :title, :description, :time_estimate, :service_ordinal)
  end
end
