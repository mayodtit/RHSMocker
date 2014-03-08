class Api::V1::TasksController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_task!, except: [:index, :current]

  def index
    authorize! :read, Task

    tasks = []
    Task.where(params.permit(:state)).order('due_at, created_at ASC').find_each do |task|
      tasks.push(task) if can? :read, task
    end

    index_resource tasks.serializer
  end

  def show
    authorize! :read, @task
    show_resource @task.serializer
  end

  def current
    task = Task.find_by_owner_id_and_state(@user.id, 'claimed')
    authorize! :read, task
    show_resource task && task.serializer
  end

  def update
    authorize! :update, @task

    update_params = params.require(:task).permit(:state_event, :owner_id, :reason_abandoned)

    if %w(assign abandon).include? update_params[:state_event]
      update_params[update_params[:state_event].event_actor.to_sym] = current_user
    end

    update_resource @task, update_params
  end

  private

  def load_task!
    @task = Task.find params[:id]
  end
end