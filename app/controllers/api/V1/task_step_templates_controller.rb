class Api::V1::TaskStepTemplatesController < Api::V1::ABaseController
  before_filter :load_service_template!, if: -> { params[:service_template_id].present? }
  before_filter :load_task_template!
  before_filter :load_task_step_templates!
  before_filter :load_task_step_template!, only: %i(show update destroy)
  before_filter :prevent_change_when_published!, only: %i(update destroy)

  def index
    index_resource @task_step_templates.serializer
  end

  def show
    show_resource @task_step_template.serializer
  end

  def create
    create_resource(@task_step_templates, permitted_params.task_step_template)
  end

  def update
    update_resource(@task_step_template, permitted_params.task_step_template)
  end

  def destroy
    destroy_resource @task_step_template
  end

  private

  def load_service_template!
    @service_template = ServiceTemplate.find(params[:service_template_id])
    authorize! :manage, @service_template
  end

  def load_task_template!
    @task_template = if @service_template
                       @service_template.task_templates.find(params[:task_template_id])
                     else
                       TaskTemplate.find(params[:task_template_id])
                     end
    authorize! :manage, @task_template
  end

  def load_task_step_templates!
    @task_step_templates = @task_template.task_step_templates
  end

  def load_task_step_template!
    @task_step_template = @task_step_templates.find(params[:id])
    authorize! :manage, @task_step_template
  end

  def prevent_change_when_published!
    @service_template ||= @task_template.service_template # protect against shallow route
    if @service_template.try(:published?) || @service_template.try(:retired?)
      render_failure({reason: "TaskStepTemplate's associated ServiceTemplate is published or retired. You cannot update it!"}, 422)
    end
  end
end
