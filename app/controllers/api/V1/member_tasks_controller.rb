# NOTE: Please use TasksController update and show
class Api::V1::MemberTasksController < Api::V1::ABaseController
  before_filter :load_member!

  def index
    authorize! :read, Task
    search_params = params.permit(:subject_id, :state)

    tasks = @member.tasks

    if search_params[:subject_id].to_i == @member.id
      tasks = tasks.where(subject_id: [params[:subject_id], nil])
      search_params.delete :subject_id
    end

    # NOTE: order is MySQL specific
    tasks = tasks.where(search_params).order("field(state, 'unclaimed', 'claimed', 'blocked_internal', 'blocked_external', 'completed', 'abandoned'), due_at DESC, created_at DESC").includes(:service_type, :owner, :member, :task_steps, :input_data_fields, :output_data_fields, :task_changes, :service_data_fields)
    index_resource tasks.serializer(for_subject: true), name: :tasks
  end

  def create
    authorize! :create, Task
    attributes = task_attributes

    attributes[:creator] = current_user
    attributes[:assignor_id] = current_user.id if attributes[:owner_id].present?
    attributes[:actor_id] = current_user.id

    @member_task = MemberTask.create(attributes.merge(member_id: @member.id))
    if @member_task.errors.empty?
      render_success(task: @member_task.serializer, entry: @member_task.entry.serializer)
    else
      render_failure({reason: @member_task.errors.full_messages.to_sentence}, 422)
    end
  end

  private

  def task_attributes
    params.require(:task).permit(:title, :description, :due_at, :time_zone, :owner_id, :subject_id, :service_type_id, :day_priority, :urgent, :service_id)
  end
end
