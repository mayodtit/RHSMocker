class Api::V1::SystemEventTemplatesController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_system_event_templates!
  before_filter :load_system_event_template!, only: %i(show update destroy)
  before_filter :convert_parameters!, only: %i(create update)

  def index
    authorize! :read, SystemEventTemplate
    index_resource @system_event_templates.serializer
  end

  def create
    authorize! :create, SystemEventTemplate
    create_resource @system_event_templates, action_params
  end

  def show
    authorize! :read, @system_event_template
    render_success system_event_template: @system_event_template.serializer,
                   all_system_event_templates: all_system_event_templates.serializer
  end

  def update
    authorize! :update, @system_event_template
    update_resource @system_event_template, action_params
  end

  def destroy
    authorize! :destroy, @system_event_template

    if @system_event_template.unpublished?
      destroy_resource @system_event_template
    else
      render_failure({reason: "You can not delete a #{@system_event_template.state} system event template."}, 422)
    end
  end

  private

  def load_system_event_templates!
    authorize! :index, SystemEventTemplate

    @system_event_templates = SystemEventTemplate.order('id DESC')

    if SystemEventTemplate::VALID_STATES.include?(params[:state])
      @system_event_templates = @system_event_templates.send(params[:state])
    end

    @system_event_templates = @system_event_templates.title_search(params[:title]) if params[:title]
  end

  def load_system_event_template!
    @system_event_template = SystemEventTemplate.find(params[:id])
    authorize! :manage, @system_event_template
  end

  def all_system_event_templates
    @system_event_template.system_relative_event_templates.all << @system_event_template
  end

  def action_params
    permitted_params.system_event_template
  end

  def convert_parameters!
    params.require(:system_event_template).change_key!(:time_offset, :time_offset_attributes)
    params.require(:system_event_template).change_key!(:system_action_template, :system_action_template_attributes)
  end
end
