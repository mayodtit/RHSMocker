class Api::V1::AppointmentTemplatesController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_appointment_templates!
  before_filter :load_appointment_template!, only: %i(show update destroy)

  def index
    index_resource @appointment_templates.serializer
  end

  def create
    create_resource @appointment_templates, permitted_params.appointment_template
  end

  def show
    show_resource @appointment_template.serializer
  end

  def update
    update_resource @appointment_template, permitted_params.appointment_template
  end

  def destroy
    destroy_resource @appointment_template
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
