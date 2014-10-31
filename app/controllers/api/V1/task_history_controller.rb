class Api::V1::TaskHistoryController < Api::V1::ABaseController
  before_filter :load_user!

  def index
    authorize! :read, Task
    query = TaskChange
    tasks = query.where( actor_id: current_user.id).order('created_at DESC')
    index_resource tasks.serializer
  end
end