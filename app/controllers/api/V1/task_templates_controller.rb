class Api::V1::TaskTemplatesController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_task_template!

  def show
    show_resource @task_template.serializer
  end

  private

  def load_task_template!
    @task_template = TaskTemplate.find(params[:id])
    authorize! :manage, @task_template
  end

end
