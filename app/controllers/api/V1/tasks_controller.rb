class Api::V1::TasksController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_task!, except: [:index, :queue, :current, :next_tasks]

  def index
    authorize! :read, Task

    tasks = Task.where(params.permit(:state, :owner_id)).where(role_id: role.id).includes(:member).order(task_order)

    index_resource tasks.serializer(shallow: true)
  end

  def queue
    authorize! :read, Task
    user = params[:pha_id] && User.find_by_id(params[:pha_id]) ? User.find(params[:pha_id]) : current_user
    tasks, tomorrow_count, future_count = user.queue(params)
    render_success tasks: tasks.serializer(shallow: true), tomorrow_count: tomorrow_count, future_count: future_count
  end

  def next_tasks
    authorize! :read, Task
    queue_tasks, tomorrow_count, future_count = current_user.queue(params)
    tasks = if queue_tasks.any?
      queue_tasks
    else
      Task.claim_next_tasks!(current_user)
    end

    render_success tasks: tasks.serializer(shallow: true)
  end

  def show
    authorize! :read, @task
    show_resource @task.serializer
  end

  def current
    task = Task.find_by_owner_id_and_state(current_user.id, 'claimed')
    authorize!(:read, task) if task
    show_resource task.try(:serializer)
  end

  def update
    authorize! :update, @task

    update_params = task_attributes
    update_params[:pubsub_client_id] = params[:pubsub_client_id]
    update_params[:actor_id] = current_user.id

    if update_params[:escalated]
      update_params[:owner_id] = Member.specialist_lead.try(:id)
      update_params[:reason_escalated] = update_params[:reason]
    end

    # NOTE 11/17/14: Support CP until its migrated over
    if update_params.has_key? :reason_abandoned
      update_params[:reason] = update_params[:reason_abandoned]
      update_params.delete :reason_abandoned
    end

    if update_params[:state_event] == 'report_blocked_by_internal' || update_params[:state_event] == 'report_blocked_by_external'
      update_params[:reason_blocked] = update_params[:reason]
    end

    if update_params.has_key?(:due_at) && update_params[:reason].blank?
      update_params[:reason] = 'no_reason_pre_cp_support'
    end

    if update_params[:state_event] == 'abandon'
      update_params[update_params[:state_event].event_actor.to_sym] = current_user
    end

    if %w(abandon complete).include?(update_params[:state_event]) && !@task.owner_id && !update_params[:owner_id]
      update_params[:owner_id] = current_user.id
    end

    if update_params[:owner_id].present? && update_params[:owner_id].to_i != @task.owner_id
      update_params[:assignor_id] = current_user.id
    end

    if update_params[:owner_id] && !update_params[:state_event] && @task.state == 'unclaimed'
      update_params[:state_event] = 'claim'
    end

    if update_params[:state_event] == 'claim'
      update_params[:owner_id] = current_user.id
    end

    if ( update_params[:state_event] == 'complete' || update_params[:state_event] == 'abandon' ) && @task.service
      @updated_tasks = @task.service.tasks.open_state.where(@task.task_template.try(:task_template_set).try(:affirmative_child_id) || @task.task_template.try(:task_template_set).try(:negative_child_id))
    end

    if @task.update_attributes(update_params)
      render_success(task: @task.serializer,
                     updated_tasks: @updated_tasks.try(:serializer, shallow: true) || [])
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
    params.require(:task).permit(:title, :description, :due_at, :state_event, :owner_id, :reason, :reason_abandoned, :member_id, :subject_id, :service_type_id, :day_priority, :pubsub_client_id, :urgent, :follow_up, :unread, :result, :escalated)
  end
end
