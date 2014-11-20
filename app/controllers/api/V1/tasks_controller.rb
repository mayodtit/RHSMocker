class Api::V1::TasksController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_task!, except: [:index, :queue, :current]

  def index
    authorize! :read, Task

    tasks = Task.where(params.permit(:state, :owner_id)).where(role_id: role.id).includes(:member).order('priority DESC, due_at ASC, created_at ASC')

    index_resource tasks.serializer(shallow: true)
  end

  def queue
    authorize! :read, Task

    query = Task.owned current_user
    if current_user.on_call?
      if Metadata.on_call_queue_only_inbound_and_unassigned?
        query = Task.needs_triage current_user
      else
        query = Task.needs_triage_or_owned current_user
      end

      if current_user.service_experiment_queue
        query = query.where(service_experiment: true)
      else
        query = query.where(service_experiment: false)
      end
    end

    tasks = query.where(role_id: role.id).includes(:member).order('priority DESC, due_at ASC, created_at ASC')

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
    update_params[:actor_id] = current_user.id

    # NOTE 11/17/14: Support CP until its migrated over
    if update_params.has_key? :reason_abandoned
      update_params[:reason] = update_params[:reason_abandoned]
      update_params.delete :reason_abandoned
    end

    if update_params.has_key?(:due_at) && update_params[:reason].blank?
      update_params[:reason] = 'no_reason_pre_cp_support'
    end

    if update_params[:state_event] == 'abandon'
      update_params[update_params[:state_event].event_actor.to_sym] = current_user
    end

    if %w(start claim abandon complete flag).include?(update_params[:state_event]) && !@task.owner_id && !update_params[:owner_id]
      update_params[:owner_id] = current_user.id
    end

    if update_params[:owner_id].present? && update_params[:owner_id].to_i != @task.owner_id
      update_params[:assignor_id] = current_user.id
    end

    update_resource @task, update_params
  end

  private

  def role
    if current_user.roles.include? Role.pha
      return Role.pha
    elsif current_user.roles.include? Role.nurse
      return Role.nurse
    end
  end

  def load_task!
    @task = Task.find params[:id]
  end

  def task_attributes
    params.require(:task).permit(:title, :description, :due_at, :state_event, :owner_id, :reason, :reason_abandoned, :member_id, :subject_id, :service_type_id)
  end
end
