class Api::V1::DataFieldTemplatesController < Api::V1::ABaseController
  before_filter :load_service_template!, if: -> { params[:service_template_id] }
  before_filter :load_data_field_templates!
  before_filter :load_data_field_template!, only: %i(show update destroy)
  before_filter :prevent_change_when_published!, only: %i(show update destroy)

  def index
    index_resource @data_field_templates.serializer
  end

  def show
    show_resource @data_field_template.serializer
  end

  def create
    create_resource(@data_field_templates, permitted_params.data_field_template)
  end

  def update
    update_resource(@data_field_template, permitted_params.data_field_template)
  end

  def destroy
    destroy_resource @data_field_template
  end

  private

  def load_service_template!
    @service_template = ServiceTemplate.find(params[:service_template_id])
    authorize! :manage, @service_template
  end

  def load_data_field_templates!
    @data_field_templates = @service_template.try(:data_field_templates)
  end

  def load_data_field_template!
    @data_field_template = if @data_field_templates
                             @data_field_templates.find(params[:id])
                           else
                             DataFieldTemplate.find(params[:id])
                           end
    authorize! :maange, @data_field_template
  end

  def prevent_change_when_published!
    @service_template ||= @data_field_template.service_template # protect against shallow route
    if @service_template.try(:published?) || @service_template.try(:retired?)
      render_failure({reason: "DataFieldTemplate's associated ServiceTemplate is published or retired. You cannot update it!"}, 422)
    end
  end
end
