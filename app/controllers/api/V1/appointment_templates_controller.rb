class Api::V1::AppointmentTemplatesController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_appointment_templates!
  before_filter :load_appointment_template!, only: %i(show update destroy)

  def index
    index_resource @appointment_templates.serializer
  end

  def create
    if unique_id = params[:appointment_template].try(:[], :unique_id)
      @current_appointment_template = AppointmentTemplate.where(unique_id: unique_id).order('version DESC').first!
      @new_appointment_template = @current_appointment_template.create_deep_copy!
      if @new_appointment_template.errors.empty?
        render_success(appointment_template: @new_appointment_template.serializer)
      else
        render_failure({reason: @new_appointment_template.errors.full_messages.to_sentence}, 422)
      end
    else
      create_resource @appointment_templates, permitted_params.appointment_template
    end
  end

  def show
    show_resource @appointment_template.serializer
  end

  def update
    update_resource @appointment_template, permitted_params.appointment_template
  end

  def destroy
    if @appointment_template.unpublished?
      destroy_resource @appointment_template
    else
      render_failure({reason: "You can not delete a #{@appointment_template.state} appointment template."}, 422)
    end
  end

  private

  def load_appointment_template!
    @appointment_template = AppointmentTemplate.find params[:id]
    authorize! :manage, @appointment_template
  end

  def load_appointment_templates!
    authorize! :index, AppointmentTemplate

    @appointment_templates = AppointmentTemplate.order('id DESC')

    case params[:state]
    when 'unpublished'
      @appointment_templates = @appointment_templates.unpublished
    when 'published'
      @appointment_templates = @appointment_templates.published
    when 'retired'
      @appointment_templates = @appointment_templates.retired
    end

    @appointment_templates = @appointment_templates.title_search(params[:title]) if params[:title]
  end
end
