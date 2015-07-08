class Api::V1::TaskTemplatesController < Api::V1::ABaseController
  before_filter :load_task_template!, only: %i(show update destroy)
  before_filter :load_task_templates!, only: %i(index create)
  before_filter :prevent_update_task_template, only: %i(update destroy)
  before_filter :load_user!

  def index
    index_resource @task_templates.serializer
  end

  def show
    show_resource @task_template.serializer
  end

  def update
    update_resource(@task_template, permitted_params.task_template)
  end

  def create
    create_resource(@task_templates, permitted_params.task_template)
  end

  def destroy
    destroy_resource @task_template
  end

  private

  def load_task_template!
    @task_template = TaskTemplate.find(params[:id])
    authorize! :manage, @task_template
  end

  def load_task_templates!
    @task_templates = TaskTemplate.where(params.permit(:service_template_id))
  end

  def prevent_update_task_template
    if @task_template.service_template.try(:published?) || @task_template.service_template.try(:retired?)
      render_failure({reason: "TaskTemplate's associated ServiceTemplate is published or retired. You cannot update it!"}, 422)
    end
  end
end
