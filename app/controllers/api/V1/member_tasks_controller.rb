# NOTE: Please use TasksController update and show
class Api::V1::MemberTasksController < Api::V1::ABaseController
  before_filter :load_member!

  def index
    authorize! :read, Task
    tasks = @member.tasks.where(params.permit(:subject_id, :state)).order('due_at, created_at ASC')
    index_resource tasks.serializer, name: :tasks
  end

  def create
    authorize! :create, Task
    attributes = task_attributes

    attributes[:creator] = current_user
    attributes[:assignor_id] = current_user.id if attributes[:owner_id].present?

    create_resource @member.tasks, attributes, name: :task
  end

  private

  def task_attributes
    params.require(:task).permit(:title, :description, :due_at, :owner_id, :subject_id, :service_type_id)
  end
end