# NOTE: Please use TasksController update and show
class Api::V1::MemberTasksController < Api::V1::ABaseController
  before_filter :load_member!

  def index
    authorize! :read, Task
    search_params = params.permit(:subject_id, :state)

    tasks = @member.tasks

    if search_params[:subject_id].to_i == @member.id
      tasks = tasks.where("type = 'ParsedNurselineRecordTask' OR type = 'WelcomeCallTask' OR subject_id = ?", params[:subject_id])
      search_params.delete :subject_id
    end

    # NOTE: order is MySQL specific
    tasks = tasks.where(search_params).order("field(state, 'unstarted', 'started', 'claimed', 'completed', 'abandoned'), due_at DESC, created_at DESC")
    index_resource tasks.serializer, name: :tasks
  end

  def create
    authorize! :create, Task
    attributes = task_attributes

    attributes[:creator] = current_user
    attributes[:assignor_id] = current_user.id if attributes[:owner_id].present?
    attributes[:actor_id] = current_user.id

    create_resource MemberTask, attributes.merge(member_id: @member.id), name: :task
  end

  private

  def task_attributes
    params.require(:task).permit(:title, :description, :due_at, :owner_id, :subject_id, :service_type_id)
  end
end