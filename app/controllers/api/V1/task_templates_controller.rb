class Api::V1::TaskTemplatesController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_task_template!
  before_filter :load_task_templates!
  before_filter :prevent_update_task_template, only: :update

  def index
    authorize! :read, TaskTemplate

    index_resource @task_templates.serializer
  end

  def show
    authorize! :read, @task_template

    show_resource @task_template.serializer
  end

  def update
    authorize! :update, @task_template

    update_resource(@task_template, permitted_params.task_template)
  end

  def create
    authorize! :create, TaskTemplate

    create_resource(@task_template, permitted_params.task_template)
  end

  def destroy
    authorize! :destroy, @task_template

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
      render_failure({reason: 'TaskTemplate\'s associated ServiceTemplate is published or retired. You cannot update it!'}, 422)
    end
  end
end
