class Api::V1::TasksController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_task!, except: [:index, :queue, :current]

  def index
    authorize! :read, Task

    tasks = []
    Task.where(params.permit(:state, :owner_id)).order('due_at, created_at ASC').each do |task|
      tasks.push(task) if can? :read, task
    end

    index_resource tasks.serializer(shallow: true)
  end

  def queue
    authorize! :read, Task

    tasks = []
    Task.unassigned_and_owned(current_user).order('due_at, created_at ASC').each do |task|
      tasks.push(task) if can? :read, task
    end

    index_resource tasks.serializer(shallow: true)
  end

  def show
    authorize! :read, @task
    show_resource @task.serializer
  end

  def current
    task = Task.find_by_owner_id_and_state(current_user.id, 'claimed')
    authorize!(:read, task) if task
    show_resource task && task.serializer
  end

  def update
    authorize! :update, @task

    update_params = task_attributes

    if %w(assign abandon).include? update_params[:state_event]
      update_params[update_params[:state_event].event_actor.to_sym] = current_user
    end

    if %w(assign start claim abandon complete).include?(update_params[:state_event]) && !@task.owner_id && !update_params[:owner_id]
      update_params[:owner_id] = current_user.id
    end

    update_resource @task, update_params
  end

  private

  def load_task!
    @task = Task.find params[:id]
  end

  def task_attributes
    params.require(:task).permit(:title, :description, :due_at, :state_event, :owner_id, :reason_abandoned, :member_id, :subject_id, :service_type_id)
  end
end