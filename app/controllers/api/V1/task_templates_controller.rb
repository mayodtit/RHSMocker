class Api::V1::TaskTemplatesController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_task_template!
  before_filter :prevent_update_task_template, only: :update

  def show
    show_resource @task_template.serializer
  end

  def update
    if @task_template.update_attributes(task_template_attributes)
      render_success(task_template: @task_template.serializer)
    else
      render_failure({reason: @task_template.errors.full_messages.to_sentence}, 422)
    end
  end

  private

  def load_task_template!
    @task_template = TaskTemplate.find(params[:id])
    authorize! :manage, @task_template
  end

  def prevent_update_task_template
    if @task_template.service_template.published? || @task_template.service_template.retired?
      render_failure({reason: 'TaskTemplate\'s associated ServiceTemplate is published or retired. You cannot update it!'}, 422)
    end
  end

  def task_template_attributes
    params.require(:task_template).permit(:name, :title, :service_template, :description, :time_estimate, :service_ordinal, :modal_template_id)
  end
end
