class Api::V1::TaskTemplatesController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_task_template!


  def show
    show_resource @task_template.serializer
  end

  def generate
    @task_template.create_task! task_template_attributes
  end


  private

  def load_task_template!
    @task_template = TaskTemplate.find(params[:id])
    authorize! :manage, @task_template
  end

  def task_template_attributes
    params.require(:id).permit(:title, :description, :member_id, :subject_id, :due_at, :owner_id)
  end

end
