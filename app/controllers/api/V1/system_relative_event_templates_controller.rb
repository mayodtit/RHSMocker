class Api::V1::SystemRelativeEventTemplatesController < Api::V1::ABaseController
  before_filter :load_system_event_template!

  def create
    @system_relative_event_template = @system_event_template.system_relative_event_templates.create
    if @system_relative_event_template.errors.empty?
      @system_relative_event_template.reload
      render_success(system_event_template: @system_relative_event_template.serializer)
    else
      render_failure({reason: @system_relative_event_template.errors.full_messages.to_sentence}, 422)
    end
  end

  private

  def load_system_event_template!
    @system_event_template = SystemEventTemplate.find(params[:system_event_template_id])
    authorize! :manage, @system_event_template
  end
end
