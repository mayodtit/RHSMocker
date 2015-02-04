class Api::V1::TasksController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_task!, except: [:index, :queue, :current]

  def index
    authorize! :read, Task

    tasks = Task.where(params.permit(:state, :owner_id)).where(role_id: role.id).includes(:member).order(task_order)

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
    end

    tasks = query.where(role_id: role.id, visible_in_queue: true).includes(:member).order(task_order)
    tomorrow_count = 0
    future_count = 0

    if params.has_key? :only_today
      eod = Time.now.pacific.end_of_day
      tom_eod = 1.day.from_now.pacific.end_of_day
      future_count = tasks.where('due_at > ?', eod).count
      tomorrow_count = tasks.where('due_at > ? && due_at <= ?', eod, tom_eod).count
      tasks = tasks.where('due_at <= ?', eod)
    end

    if params.has_key? :until_tomorrow
      eod = Time.now.pacific.end_of_day
      tom_eod = 1.day.from_now.pacific.end_of_day
      future_count = tasks.where('due_at > ?', tom_eod).count
      tasks = tasks.where('due_at <= ?', tom_eod)
    end

    render_success tasks: tasks.serializer(shallow: true), tomorrow_count: tomorrow_count, future_count: future_count
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

    if update_params[:state_event] == 'claim'
      @updated_tasks = Task.claimed.where(owner_id: current_user.id).each do |t|
        t.actor_id = current_user.id
        t.pubsub_client_id = update_params[:pubsub_client_id]
        t.start!
      end
    end

    if @task.update_attributes(update_params)
      render_success(task: @task.serializer,
                     updated_tasks: @updated_tasks.try(:serializer) || [])
    else
      render_failure({reason: @task.errors.full_messages.to_sentence}, 422)
    end
  end

  private

  def task_order
    pacific_offset = Time.zone_offset('PDT')/3600
    "DATE(CONVERT_TZ(due_at, '+0:00', '#{pacific_offset}:00')) ASC, priority DESC, day_priority DESC, due_at ASC, created_at ASC"
  end

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
    params.require(:task).permit(:title, :description, :due_at, :state_event, :owner_id, :reason, :reason_abandoned, :member_id, :subject_id, :service_type_id, :day_priority, :pubsub_client_id)
  end
end
