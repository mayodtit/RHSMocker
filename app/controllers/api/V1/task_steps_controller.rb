class Api::V1::TaskStepsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_task_step!

  def show
    show_resource @task_step.serializer
  end

  def update
    update_resource @task_step, update_params
  end

  private

  def load_task_step!
    @task_step = TaskStep.find(params[:id])
    authorize! :manage, @task_step
  end

  def update_params
    permitted_params.task_step.tap do |attributes|
      attributes[:actor] = current_user
    end
  end
end
