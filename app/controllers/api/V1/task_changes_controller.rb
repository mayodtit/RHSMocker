class Api::V1::TaskChangesController < Api::V1::ABaseController
  before_filter :load_user!

  def index
    authorize! :read, Task
    query = TaskChange
    tasks = query.where( actor_id: current_user.id).order('created_at DESC').includes(:task, :actor)
    index_resource tasks.serializer(shallow: true)
  end
end